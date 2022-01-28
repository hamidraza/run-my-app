import SwiftUI

struct LsofLog: Identifiable {
    let id = UUID()
    
    let command: String
    let pid: String
    let user: String
    let fd: String
    let type: String
    let device: String
    let size: String
    let node: String
    let name: String
    
    init(_ cells: [String]) {
        self.command = cells[0]
        self.pid = cells[1]
        self.user = cells[2]
        self.fd = cells[3]
        self.type = cells[4]
        self.device = cells[5]
        self.size = cells[6]
        self.node = cells[7]
        self.name = cells[8]
    }
}

struct UtilCmdView: View {
    @State private var port: String = ""
    @State private var completeCmd = ""
    @State private var logs: [String] = []
    @State private var alertItem: AlertItem?
    
    @State private var lsoflogs: [LsofLog] = []
    @State private var selectedRow = Set<LsofLog.ID>()
    
    var body: some View {
        VStack(alignment: .leading) {
            Table(lsoflogs, selection: $selectedRow) {
                TableColumn("Command", value: \.command)
                TableColumn("PID", value: \.pid)
                TableColumn("User", value: \.user)
                TableColumn("FD", value: \.fd)
                TableColumn("Type", value: \.type)
                TableColumn("Device", value: \.device)
                TableColumn("SIZE/OFF", value: \.size)
                TableColumn("Node", value: \.node)
                TableColumn("Name", value: \.name)
            }
            if !self.selectedRow.isEmpty {
                HStack(alignment: .firstTextBaseline) {
                    Spacer()
                    Button("Kill selected Process", action: handleKillProcesses)
                }
                .padding()
                .background(BlurView())
            }
        }
        
        .frame(minWidth: 600, minHeight: 400)
        .navigationTitle("lsof")
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                TextField("Enter port", text: $port)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minWidth: 60)
                    .onSubmit(submitPort)
                Button(action: submitPort, label: {
                    Label("Run", systemImage: "play.fill")
                })
            }
        }
        .alert(item: $alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }

    func submitPort() {
        let p = port.trimmingCharacters(in: .whitespacesAndNewlines)
        guard p != "" else {
            self.alertItem = AlertItem(
                title: Text("Invalid port"),
                message: Text("Please enter a valid port number")
            )
            return
        }
        
        var outLogs = Helper.shell(["lsof -i tcp:\(port)"]).split(separator: "\n").map{ String($0) }
        guard outLogs.first != nil else {
            self.alertItem = AlertItem(
                title: Text("No process found"),
                message: Text("No process running which is using port :\(self.port)")
            )
            self.lsoflogs.removeAll()
            return
        }
        outLogs.removeFirst()
        self.lsoflogs = outLogs.map { ol -> LsofLog in
            var row = ol.split(separator: " ").map{ "\($0)" }
            let last = row.removeLast()
            row[row.count-1] = "\(row[row.count-1]) \(last)"
            return LsofLog(row)
        }
    }
    
    func handleKillProcesses() {
        let pids = self.lsoflogs.filter{ selectedRow.contains($0.id) }.map{ $0.pid }
        let outLogs = Helper.shell(["kill -9 \(pids.joined(separator: " "))"])
        self.lsoflogs.removeAll{ pids.contains($0.pid) }
        self.selectedRow.removeAll()
        if outLogs.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            self.alertItem = AlertItem(title: Text("Alert!"), message: Text(outLogs))
        }
    }
}

struct UtilCmdView_Previews: PreviewProvider {
    static var previews: some View {
        UtilCmdView()
    }
}
