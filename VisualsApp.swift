//
//  VisualsApp.swift
//  Visuals - A Modern Visualization App
//
//  Co-Authored-By: Oz <oz-agent@warp.dev>
//

import SwiftUI

@main
struct VisualsApp: App {
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
