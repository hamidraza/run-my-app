import Foundation

enum ProjectType {
    case node, python, ruby, html;
}

enum NodeProjectType {
    case npm, yarn
}

struct PackageJSONObj: Codable {
    var scripts: [String: String]
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

class ProjectItem: Cmd {

    var type: ProjectType = .html
    var nodeProjectType: NodeProjectType = .npm
    var npmScripts: [String: String] = [:]
    var hasNpx: Bool? = nil
    var pyVersion: String = ""
    
    init(_ projectPath: String) {
        super.init(projectPath)
        
        let packageJsonPath = "\(self.path)/package.json";
        if Helper.fileExists(atPath: packageJsonPath) {
            self.type = .node

            do {
                let packageJsonData = try Data(contentsOf: URL(fileURLWithPath: packageJsonPath))
                self.npmScripts = try JSONDecoder().decode(PackageJSONObj.self, from: packageJsonData).scripts
            } catch {
                print("error: \(error)")
            }
            
            if Helper.fileExists(atPath: "\(self.path)/yarn.lock") {
                self.nodeProjectType = .yarn
            }
        }
    }

    override var name: String {
        get {
            return self.task.currentDirectoryURL?.lastPathComponent ?? ""
        }
    }
    
    var path: String {
        get {
            return self.task.currentDirectoryURL?.path ?? ""
        }
    }
    
    var formattedPath: String {
        get {
            return self.path.replacingOccurrences(of: "/Users/\(NSUserName())/", with: "~/")
        }
    }
    
    override func run(_ arguments: [String] = []) {
        let command = arguments.joined(separator: " ")
        
        // Node project
        if self.type == .node {
            if self.nodeProjectType == .yarn {
                super.run(["yarn \(command)"])
            } else {
                super.run(["npm run \(command)"])
            }
            return
        }

        // Static project
        if self.hasNpx == nil {
            self.hasNpx = Helper.checkIfCmdExists("npx")
        }
        
        if self.hasNpx == true {
            super.run(["npx -y http-server -p \(command)"])
        } else {
            if self.pyVersion == "" {
                self.pyVersion = Helper.shell(["python --version"]).replacingOccurrences(of: "Python ", with: "")
            }
            if "3".compare(self.pyVersion, options: .numeric) == .orderedAscending {
                super.run(["python -m http.server \(command)"])
            } else {
                super.run(["python -m SimpleHTTPServer \(command)"])
            }
        }
    }
    
    func toggle(_ arguments: [String] = []) {
        if self.task.isRunning {
            return self.stop()
        }
        self.run(arguments)
    }
}

class AppState: ObservableObject {
    @Published var projects: [ProjectItem] = [
    ]
}
