import Foundation

enum UtilCmd {
    case lsof, kill
}

class LogLine: Identifiable {
    var id = UUID()
    var text: String
    var isError: Bool

    init(_ text: String, isError: Bool = false) {
        self.text = text
        self.isError = isError
    }
}

class CmdModel: ObservableObject, Identifiable {
    var id = UUID().uuidString
    
    @Published var task: Process
    @Published var logs: [LogLine] = []
    @Published var isRunning = false
    var exePath: String? = nil
    
    var name: String {
        get {
            return self.exePath?.components(separatedBy: "/").last ?? ""
        }
    }
    
    init(_ pwd: String? = nil, exePath: String? = nil) {
        self.task = Helper.createProcess(url: pwd != nil ? URL(fileURLWithPath: pwd!) : nil)
        self.exePath = exePath
    }
    
    func run(_ arguments: [String] = []) {
        self.isRunning = true
        
        Helper.runTask(task: task, arguments: (exePath != nil ? [exePath!] : []) + arguments) { log in
            self.logs.append(LogLine(log.trimmingCharacters(in: .whitespacesAndNewlines)))
        } observeError: { log in
            self.logs.append(LogLine(log.trimmingCharacters(in: .whitespacesAndNewlines), isError: true))
        } onTerminate: {
            self.logs.append(LogLine("[Process completed]\n"))
            self.isRunning = false

            // re-initialise task, once current task is terminated.
            self.task = Helper.createProcess(url:self.task.currentDirectoryURL?.absoluteURL)
        }
    }

    func stop() {
        task.terminate()
    }
}
