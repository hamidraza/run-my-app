import SwiftUI

struct BlurView: NSViewRepresentable {
    func makeNSView(context: Context) -> some NSView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        return view
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
    }
}
