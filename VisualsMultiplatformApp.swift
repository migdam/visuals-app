//
//  VisualsMultiplatformApp.swift
//  Visuals - Multiplatform
//
//  Co-Authored-By: Oz <oz-agent@warp.dev>
//

import SwiftUI

@main
struct VisualsMultiplatformApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
        #endif
    }
}
