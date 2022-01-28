import SwiftUI

struct Line: Identifiable {
    let id = UUID()
    let text: String
}

struct MainView: View {
    @StateObject var mainData = MainVM()
    @State private var alertItem: AlertItem?

    var body: some View {
        NavigationView {
            SidebarView()
            DefaultView()
                .frame(minWidth: 600, minHeight: 400)
                .onDrop(of: ["public.file-url"], isTargeted: nil) { (items) -> Bool in
                    return self.handleProjectDrop(items: items)
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
        .environmentObject(mainData)
        .alert(item: $alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
    }

    private func toggleSidebar() {
        #if os(macOS)
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }

    private func handleProjectDrop(items: [NSItemProvider]) -> Bool {
        if items.isEmpty { return false }

        items.forEach { item in
            guard let identifier = item.registeredTypeIdentifiers.first else { return }

            item.loadItem(forTypeIdentifier: identifier, options: nil) { (urlData, error) in
                let url = NSURL(absoluteURLWithDataRepresentation: urlData as! Data, relativeTo: nil) as URL
                DispatchQueue.main.async {
                    if(url.hasDirectoryPath) {
                        mainData.addProject(path: url.absoluteString)
                    } else {
                        self.alertItem = AlertItem(
                            title: Text("Invalid project"),
                            message: Text("Please drop a directory\ncontaining your project.\n\nIndividual files are not supported yet :(")
                        )
                    }
                }
            }
        }

        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
