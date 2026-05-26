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
    @State private var showSidebar: Bool = false
    @StateObject private var audioManager = AudioManager.shared
    @State private var droppedImage: NSImage? = nil
    @State private var imageOpacity: Double = 0.3
    @State private var showDropIndicator: Bool = false
    
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
            
            // Dropped image overlay
            if let image = droppedImage {
                #if os(macOS)
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .opacity(imageOpacity)
                    .blendMode(.screen)
                    .ignoresSafeArea()
                #endif
            }
            
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
                case .glassCards:
                    GlassCardsView(
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
            
            // Drop indicator
            if showDropIndicator {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(style: StrokeStyle(lineWidth: 4, dash: [10]))
                    .foregroundColor(.white)
                    .padding(40)
                    .overlay(
                        VStack {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            Text("Drop Image Here")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(.top, 10)
                        }
                    )
                    .background(.ultraThinMaterial.opacity(0.5))
                    .transition(.opacity)
            }
            
            // Overlay dimmer when sidebar is open
            if showSidebar {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showSidebar = false
                        }
                    }
                    .transition(.opacity)
                    .zIndex(0)
            }
            
            // Sidebar navigation
            HStack(spacing: 0) {
                if showSidebar {
                    SidebarView(
                        selectedVisualization: $selectedVisualization,
                        colorScheme: $colorScheme,
                        speed: $speed,
                        density: $density,
                        showSidebar: $showSidebar,
                        droppedImage: $droppedImage,
                        imageOpacity: $imageOpacity
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    .zIndex(1)
                }
                
                Spacer()
            }
            
            // Menu button (only show when sidebar is hidden)
            if !showSidebar {
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showSidebar.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .buttonStyle(.plain)
                        .padding(20)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .transition(.opacity)
            }
            
            // Native drop target overlay (invisible but captures drops)
            #if os(macOS)
            ImageDropView(droppedImage: $droppedImage, showDropIndicator: $showDropIndicator)
                .ignoresSafeArea()
                .allowsHitTesting(false)
            #endif
        }
        .gesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    let horizontalAmount = value.translation.width
                    let verticalAmount = value.translation.height
                    
                    // Only trigger if drag is mostly horizontal
                    if abs(horizontalAmount) > abs(verticalAmount) {
                        // Swipe from left edge to open
                        if !showSidebar && value.startLocation.x < 50 && horizontalAmount > 80 {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showSidebar = true
                            }
                        }
                        // Swipe left to close
                        else if showSidebar && horizontalAmount < -80 {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showSidebar = false
                            }
                        }
                    }
                }
        )
        .onAppear {
            // Start ambient sound for initial visualization
            audioManager.startAmbientSound(for: selectedVisualization)
        }
    }
}

enum VisualizationType: String, CaseIterable {
    case particles = "Particles"
    case sphere = "3D Sphere"
    case glassCards = "Glass Cards"
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
