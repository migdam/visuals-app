//
//  ContentView.swift
//  Visuals
//
//  Co-Authored-By: Oz <oz-agent@warp.dev>
//

import SwiftUI

struct ContentView: View {
    @State private var selectedVisualization: VisualizationType = .particles
    @State private var colorScheme: ColorSchemeType = .cosmic
    @State private var speed: Double = 1.0
    @State private var density: Double = 100
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: colorScheme.backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            #if os(iOS)
            .ignoresSafeArea(.all, edges: .all)
            #else
            .ignoresSafeArea()
            #endif
            
            // Main visualization
            Group {
                switch selectedVisualization {
                case .particles:
                    ParticleSystemView(
                        colorScheme: colorScheme,
                        speed: speed,
                        density: Int(density)
                    )
                case .sphere:
                    SphereView(
                        colorScheme: colorScheme,
                        speed: speed
                    )
                case .waves:
                    WaveVisualizationView(
                        colorScheme: colorScheme,
                        speed: speed
                    )
                case .galaxy:
                    GalaxyView(
                        colorScheme: colorScheme,
                        speed: speed
                    )
                case .aurora:
                    AuroraView(
                        colorScheme: colorScheme,
                        speed: speed
                    )
                }
            }
            
            // Control panel
            VStack {
                Spacer()
                
                ControlPanel(
                    selectedVisualization: $selectedVisualization,
                    colorScheme: $colorScheme,
                    speed: $speed,
                    density: $density
                )
                .padding()
            }
        }
    }
}

enum VisualizationType: String, CaseIterable {
    case particles = "Particles"
    case sphere = "3D Sphere"
    case waves = "Waves"
    case galaxy = "Galaxy"
    case aurora = "Aurora"
}

enum ColorSchemeType: String, CaseIterable {
    case cosmic = "Cosmic"
    case ocean = "Ocean"
    case sunset = "Sunset"
    case forest = "Forest"
    case monochrome = "Monochrome"
    
    var backgroundColors: [Color] {
        switch self {
        case .cosmic:
            return [Color(red: 0.1, green: 0.0, blue: 0.2), Color(red: 0.0, green: 0.0, blue: 0.1)]
        case .ocean:
            return [Color(red: 0.0, green: 0.2, blue: 0.4), Color(red: 0.0, green: 0.05, blue: 0.15)]
        case .sunset:
            return [Color(red: 0.3, green: 0.1, blue: 0.2), Color(red: 0.1, green: 0.0, blue: 0.15)]
        case .forest:
            return [Color(red: 0.0, green: 0.2, blue: 0.15), Color(red: 0.0, green: 0.1, blue: 0.05)]
        case .monochrome:
            return [Color(white: 0.05), Color.black]
        }
    }
    
    var particleColors: [Color] {
        switch self {
        case .cosmic:
            return [.purple, .blue, .pink, .cyan]
        case .ocean:
            return [.cyan, .blue, Color(red: 0.0, green: 0.5, blue: 0.7), Color(red: 0.1, green: 0.8, blue: 0.9)]
        case .sunset:
            return [.orange, .red, .pink, .yellow]
        case .forest:
            return [.green, Color(red: 0.0, green: 0.8, blue: 0.4), Color(red: 0.2, green: 1.0, blue: 0.3)]
        case .monochrome:
            return [.white, .gray, Color(white: 0.8), Color(white: 0.6)]
        }
    }
}
