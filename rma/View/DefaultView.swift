import SwiftUI

struct DefaultView: View {
    @EnvironmentObject var mainData: MainVM

    var body: some View {
        VStack(spacing: 16) {
            Text("🤪")
                .font(.system(size: 56))
            VStack(spacing: 20) {
                Text("No project selected")
                    .font(.title)
                VStack {
                    HStack {
                        Button {
                            self.mainData.browseAndAddProject()
                        } label: {
                            Label("Add a project", systemImage: "plus")
                        }.buttonStyle(LinkButtonStyle())
                    }
                    if mainData.projects.count > 0 {
                        Text("or, select a project from Sidebar")
                            .font(.caption2)
                    }
                }
            }
        }
    }
}

struct DefaultView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultView()
    }
}
