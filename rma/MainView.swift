import SwiftUI

struct Line: Identifiable {
    let id = UUID()
    let text: String
}

struct MainView: View {
    @StateObject var appState = AppState()

    @State private var selectedNavItem: String?
    @State private var message = "Hello, World!"
    @State private var isTaskRunning = false
    @State private var task = Process()
    @State private var lines: [Line] = []
    @State private var pwdUrl: URL? = nil

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List(selection: $selectedNavItem) {
                    Section(header: Text("Projects")) {
                        ForEach($appState.projects) { $project in
                            NavigationLink(
                                destination: ProjectView(project: project),
                                tag: "project-\(project.name)",
                                selection: $selectedNavItem
                            ) {
                                Image(systemName: "folder.fill")
                                VStack(alignment: .leading) {
                                    Text(project.formattedPath)
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Common utils/cmds")) {
                        NavigationLink(
                            destination: UtilCmdView(),
                            tag: "cmd-lsof",
                            selection: $selectedNavItem
                        ) {
                            Image(systemName: "greetingcard.fill")
                            Text("find PID using :port")
                        }
                    }
                }

                Button(action: {
                    if let p = Helper.browseFolder() {
                        self.appState.projects.append(ProjectItem(p))
                    }
                }, label: {
                    Label("Add Project", systemImage: "plus")
                }).padding().buttonStyle(.plain)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigation) {
                Button(action: toggleSidebar, label: {
                    Label("Toggle sidebar", systemImage: "sidebar.leading")
                })
            }
        }
        .presentedWindowToolbarStyle(ExpandedWindowToolbarStyle())
    }
    
    private func toggleSidebar() {
        #if os(macOS)
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
