import Foundation
import SwiftUI

enum ShellType {
    case sh, zsh, bash
}

class Helper{
    static func createProcess(url: URL? = nil, shellType: ShellType? = .bash) -> Process {
        let task = self.newTask()
        if let u = url {
            task.currentDirectoryURL = u
        }
        return task
    }
    
    static func runTask(task: Process, arguments: [String], observeLine: @escaping (String) -> (), observeError: @escaping (String) -> (), onTerminate: @escaping () -> ()) {
        
        task.arguments = (task.arguments ?? []) + arguments.filter({ $0 != ""})
        
        let pipe = Pipe()
        task.standardOutput = pipe
        let outputHandler = pipe.fileHandleForReading
        outputHandler.waitForDataInBackgroundAndNotify()
        var dataObserver: NSObjectProtocol!
        let dataNotificationCenter = NotificationCenter.default
        dataObserver = dataNotificationCenter.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputHandler, queue: nil) {  notification in
            let data = outputHandler.availableData
            if data.count > 0 {
                if let str = String(data: data, encoding: String.Encoding.utf8) {
                    observeLine(str.trimmingCharacters(in: .whitespacesAndNewlines))
                }
                outputHandler.waitForDataInBackgroundAndNotify()
            } else {
                NotificationCenter.default.removeObserver(dataObserver!)
            }
        }
        
        let errPipe = Pipe()
        task.standardError = errPipe
        let errOutHandler = errPipe.fileHandleForReading
        errOutHandler.waitForDataInBackgroundAndNotify()
        var errObserver: NSObjectProtocol!
        let errNotificationCenter = NotificationCenter.default
        errObserver = errNotificationCenter.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: errOutHandler, queue: nil) {  notification in
            let data = errOutHandler.availableData
            if data.count > 0 {
                if let str = String(data: data, encoding: String.Encoding.utf8) {
                    observeError(str.trimmingCharacters(in: .whitespacesAndNewlines))
                }
                errOutHandler.waitForDataInBackgroundAndNotify()
            } else {
                NotificationCenter.default.removeObserver(errObserver!)
            }
        }
        
        var terminationObserver: NSObjectProtocol!
        let terminationNotificationCenter = NotificationCenter.default
        terminationObserver = terminationNotificationCenter.addObserver(forName: Process.didTerminateNotification, object: task, queue: nil) { notification in
            terminationNotificationCenter.removeObserver(terminationObserver!)
            onTerminate()
        }

        do {
            try task.run()
        } catch {
            observeLine("ERROR: \(error.localizedDescription)")
            onTerminate()
        }
    }
    
    static func browseFolder() -> String? {
        var pwdUrl: URL? = nil
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        if panel.runModal() == .OK {
            pwdUrl = panel.url
        }
        return pwdUrl?.absoluteString
    }

    static func log(_ text: String) {
        print("\n\n\n=====\n")
        print(text)
        print("\n=====\n\n\n")
    }
    
    static func fileExists(atPath: String) -> Bool {
        return FileManager.default.fileExists(atPath: atPath)
    }

    static func shell(_ arguments: [String], skipInteractive: Bool = false) -> String {
        let task = self.newTask(arguments, skipInteractive: skipInteractive)
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    static func newTask(_ arguments: [String] = [], skipInteractive: Bool = false) -> Process {
        let task = Process()
        task.launchPath = "/bin/zsh"
        if skipInteractive {
            task.arguments = ["-c"] + arguments
        } else {
            task.arguments = ["-lic"] + arguments
        }
        return task
    }
    
    static func checkIfCmdExists(_ cmd: String) -> Bool {
        let result = self.shell(["which \(cmd)"]).trimmingCharacters(in: .whitespacesAndNewlines)
        return result != "" && result != "\(cmd) not found"
    }
}
