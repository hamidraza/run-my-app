import SwiftUI

struct ProjectView: View {
    @EnvironmentObject var mainData: MainVM

    @ObservedObject var project: ProjectItem
    @State private var npmScript: String = "start"
    @State private var staticPort: String = "8000"

    var body: some View {
        ScrollViewReader { scrollValue in
            List ($project.logs) { $log in
                Text(log.text)
                    .font(.subheadline)
                    .lineLimit(nil)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .foregroundColor(log.isError ? .red : nil)
                    .id(log.id)
            }
            .onAppear {
                scrollValue.scrollTo(project.logs.last?.id)
            }
            .onChange(of: project.logs.count) { _ in
                scrollValue.scrollTo(project.logs.last?.id)
            }
        }
        .frame(minWidth: 600, minHeight: 400)
        .navigationTitle(project.formattedPath)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                
                if project.type == .node {
                    HStack {
                        Picker("Script", selection: $npmScript) {
                            Section(header: Text("Scripts")) {
                                ForEach(project.npmScripts.sorted(by: >), id: \.key) { key, value in
                                    HStack {
                                        Text(key)
                                        Text(value)
                                    }.tag(key)
                                }
                            }
                        }
                    }
                }
                if project.type == .html {
                    HStack {
                        Text("Port:")
                        TextField("", text: $staticPort)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(minWidth: 60)
                    }
                }

                Button(action: handleStartStopTask, label: {
                    Label("Run", systemImage: project.isRunning ? "stop.fill" : "play.fill")
                })
                
                HStack {
                    Text("")
                        .frame(width: 32)
                }
                
                Menu {
                    Section(header: Text("Open with")) {
                        ForEach(Constant.openWithAppList, id: \.id) { id, label in
                            if let app = Helper.urlForApplication(withBundleIdentifier: id) {
                                Button(label) { _ = Helper.openWithApp(app: app, dir: project.path) }
                            }
                        }
                    }
                    Divider()
                    Section(header: Text("Actions")) {
                        Button(role: .destructive, action: {
                            self.mainData.removeProject(id: self.project.id)
                        }) {
                            Label("Remove project", systemImage: "trash")
                        }.disabled(self.project.isRunning)
                    }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
        }
    }
    
    func handleStartStopTask() {
        project.toggle(project.type == .node ? [npmScript] : [staticPort])
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(project: ProjectItem("/"))
    }
}
