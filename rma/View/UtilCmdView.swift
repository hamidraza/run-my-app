import SwiftUI

struct UtilCmdView: View {
    @State private var port: String = ""
    @State private var completeCmd = ""
    @State private var logs: [String] = []
    @State private var showPortWarning: Bool = false
    
    var body: some View {
        List($logs, id: \.self) { $log in
            Text(log)
        }
        .alert(isPresented: $showPortWarning) {
            Alert(title: Text("Invalid port"), message: Text("Please enter a valid port number"), dismissButton: .default(Text("OK")))
        }
        .background(Color.red)
        .navigationTitle("lsof")
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                TextField("Enter port", text: $port)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minWidth: 60)
                    .onSubmit {
                        submitPort()
                    }
                Button(action: submitPort, label: {
                    Label("Run", systemImage: "play.fill")
                })
            }
        }
    }

    func submitPort() {
        let p = port.trimmingCharacters(in: .whitespacesAndNewlines)
        if p == "" {
            showPortWarning = true
        } else {
            let result = Helper.shell(["lsof -i tcp:\(port)"])
            self.logs = result.split(separator: "\n").map{ String($0) }
        }
    }
}

struct UtilCmdView_Previews: PreviewProvider {
    static var previews: some View {
        UtilCmdView()
    }
}
