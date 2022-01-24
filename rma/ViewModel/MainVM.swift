import Foundation

class MainVM: ObservableObject {
    @Published var projects: [ProjectItem] = []
    @Published var selectedNav: String? = nil
    
    func selectProject(_ id: String?) {
        self.selectedNav = id
    }

    func addProject(path p: String) {
        if let project = self.projects.first(where: {$0.task.currentDirectoryURL?.absoluteString == p}) {
            self.selectProject(project.id)
            return;
        }

        let project = ProjectItem(p)
        self.projects.append(project)
        self.selectProject(project.id)
    }

    func removeProject(id: String) {
        self.projects.removeAll(where: {$0.id == id})
        self.selectProject(self.projects.first?.id)
    }
    
    func browseAndAddProject() {
        if let p = Helper.browseFolder() {
            self.addProject(path: p)
        }
    }
}
