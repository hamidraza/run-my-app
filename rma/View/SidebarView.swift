import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var mainData: MainVM

    var body: some View {
        VStack(alignment: .leading) {
            List(selection: $mainData.selectedNav) {
                Section(header: Text("Projects")) {
                    ForEach($mainData.projects) { $project in
                        NavigationLink(
                            destination: ProjectView(project: project),
                            tag: project.id,
                            selection: $mainData.selectedNav
                        ) {
                            Image(systemName: "folder.fill")
                            VStack(alignment: .leading) {
                                Text(project.formattedPath)
                            }
                        }
                    }
                    if mainData.projects.isEmpty {
                        Button {
                            mainData.browseAndAddProject()
                        } label: {
                            Label("Add a project", systemImage: "plus")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }

                Section(header: Text("Common utils/cmds")) {
                    NavigationLink(
                        destination: UtilCmdView(),
                        tag: "cmd-lsof",
                        selection: $mainData.selectedNav
                    ) {
                        Image(systemName: "greetingcard.fill")
                        Text("find PID using :port")
                    }
                }
            }

            Button(action: {
                self.mainData.browseAndAddProject()
            }, label: {
                Label("Add Project", systemImage: "plus")
            }).padding().buttonStyle(.plain)
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
