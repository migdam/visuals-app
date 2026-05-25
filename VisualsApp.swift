//
//  VisualsApp.swift
//  Visuals - A Modern Visualization App
//
//  Co-Authored-By: Oz <oz-agent@warp.dev>
//

import SwiftUI

@main
struct VisualsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillTerminate(_ notification: Notification) {
        // Clean up audio when app quits
        AudioManager.shared.stopAmbientSound()
    }
}
