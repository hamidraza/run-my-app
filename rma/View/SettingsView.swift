import SwiftUI

struct GeneralSettingsView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

    var body: some View {
        VStack(spacing: 32) {
            Image("icon")
                .resizable()
                .frame(width: 64, height: 64)
            
            VStack(spacing: 8) {
                Text("Run My App")
                    .font(.title2)
                
                if let v = appVersion {
                    HStack(spacing: 0) {
                        Text("Version \(v)")
                            .font(.caption2)
                        if let b = buildNumber {
                            Text(" (\(b))")
                                .font(.caption2)
                        }
                    }
                }
            }
            
            VStack(spacing: 8) {
                Text("If you have any feedback/comments")
                Text("Please write to rma@hamid.tech")
            }
        }
        .padding()
        .frame(width: 500, height: 300)
    }
}

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, advanced
    }

    var body: some View {
        GeneralSettingsView()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
