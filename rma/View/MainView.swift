import SwiftUI

struct Line: Identifiable {
    let id = UUID()
    let text: String
}

struct MainView: View {
    @StateObject var mainData = MainVM()

    var body: some View {
        NavigationView {
            SidebarView()
            DefaultView()
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
