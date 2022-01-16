//
//  ProjectView.swift
//  cldr
//
//  Created by Hamid on 08/01/22.
//

import SwiftUI

struct ProjectView: View {
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
        .navigationTitle(project.formattedPath)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                if project.type == .node {
                    HStack {
                        Text("Script")
                        Picker("Script", selection: $npmScript) {
                            ForEach(project.npmScripts.sorted(by: >), id: \.key) { key, value in
                                HStack {
                                    Text(key)
                                    Text(value)
                                }.tag(key)
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
//                Menu {
//                    Button {
//                        print("Menu")
//                    } label: {
////                        Label("Menu")
//                        Label("Menu", systemImage: "slider.horizontal.3")
//                    }
//
//                }
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
