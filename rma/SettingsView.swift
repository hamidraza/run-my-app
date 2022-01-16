//
//  SettingsView.swift
//  cldr
//
//  Created by Hamid on 08/01/22.
//

import SwiftUI

struct TextFieldWithBrowse: View {
    var label: String
    @Binding var value: String

    var body: some View {
        HStack {
            TextField(label, text: $value)
            Button {
                if let path = Helper.browseFolder() {
                    value = path
                }
                print("browse")
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
}

struct GeneralSettingsView: View {
    
    @AppStorage("defaultShell") private var defaultShell = ""
    @AppStorage("nodePath")     private var nodePath = ""
    @AppStorage("npmPath")      private var npmPath = ""
    @AppStorage("yarnPath")     private var yarnPath = ""
    @AppStorage("pythonPath")   private var pythonPath = ""
    @AppStorage("rubyPath")     private var rubyPath = ""
    
    init() {
        if defaultShell == "" {
            defaultShell = "/bin/bash"
        }
        if pythonPath == "" {
            pythonPath = "/usr/bin/python3"
        }
        if rubyPath == "" {
            rubyPath = "/usr/bin/ruby"
        }
    }

    var body: some View {
        ScrollView {
            Form {
                TextFieldWithBrowse(label: "shell", value: $defaultShell)
                TextFieldWithBrowse(label: "node", value: $nodePath)
                TextFieldWithBrowse(label: "npm", value: $npmPath)
                TextFieldWithBrowse(label: "yarn", value: $yarnPath)
                TextFieldWithBrowse(label: "python", value: $pythonPath)
                TextFieldWithBrowse(label: "ruby", value: $rubyPath)
            }
        }
        .frame(width: 450, height: 250)
    }
}

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, advanced
    }

    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
        }
        
        .padding()
//        .frame(width: 350, height: 100)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
