//
//  cldrApp.swift
//  cldr
//
//  Created by Hamid on 20/12/21.
//

import SwiftUI

@main
struct rmaApp: App {
    
//    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .commands {
            SidebarCommands()
        }
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}

//class AppDelegate: NSObject, NSApplicationDelegate {
//
//    var statusItem: NSStatusItem?
//    var popOver = NSPopover()
//
//    func applicationDidFinishLaunching(_ notification: Notification) {
//        let contentView = ContentView()
//
//        popOver.behavior = .transient
//        popOver.animates = true
//        popOver.contentViewController = NSViewController()
//        popOver.contentViewController?.view = NSHostingView(rootView: contentView)
//        popOver.contentViewController?.view.window?.makeKey()
//        popOver.contentSize = NSSize(width: 400, height: 400)
//
//        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
//
//        if let MenuButton = statusItem?.button {
//            MenuButton.image = NSImage(systemSymbolName: "terminal.fill", accessibilityDescription: nil)
//            MenuButton.action = #selector(MenuButtonToggle)
//        }
//    }
//
//    @objc func MenuButtonToggle(sender: AnyObject) {
//        if popOver.isShown {
//            popOver.performClose(sender)
//        } else {
//            if let menuButton = statusItem?.button {
//                self.popOver.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: NSRectEdge.minY)
//            }
//        }
//    }
//}
