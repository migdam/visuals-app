//
//  SidebarView.swift
//  Visuals
//
//  Co-Authored-By: Oz <oz-agent@warp.dev>
//

import SwiftUI

struct SidebarView: View {
    @Binding var selectedVisualization: VisualizationType
    @Binding var colorScheme: ColorSchemeType
    @Binding var speed: Double
    @Binding var density: Double
    @Binding var showSidebar: Bool
    @ObservedObject var audioManager = AudioManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Visuals")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        showSidebar.toggle()
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(8)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            Divider()
                .background(Color.white.opacity(0.2))
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Visualizations Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Visualizations")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                            .textCase(.uppercase)
                            .padding(.horizontal, 20)
                        
                        ForEach(VisualizationType.allCases, id: \.self) { type in
                            Button(action: {
                                AudioManager.shared.playTransitionSound()
                                withAnimation(.spring(response: 0.3)) {
                                    selectedVisualization = type
                                }
                                AudioManager.shared.startAmbientSound(for: type)
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: iconForVisualization(type))
                                        .font(.system(size: 18))
                                        .frame(width: 28)
                                        .foregroundColor(selectedVisualization == type ? .white : .white.opacity(0.6))
                                    
                                    Text(type.rawValue)
                                        .font(.system(size: 15, weight: selectedVisualization == type ? .semibold : .regular))
                                        .foregroundColor(selectedVisualization == type ? .white : .white.opacity(0.8))
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    selectedVisualization == type ?
                                    Color.white.opacity(0.15) : Color.clear
                                )
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 8)
                        }
                    }
                    .padding(.top, 20)
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                        .padding(.horizontal, 20)
                    
                    // Color Schemes Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Color Schemes")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                            .textCase(.uppercase)
                            .padding(.horizontal, 20)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(ColorSchemeType.allCases, id: \.self) { scheme in
                                Button(action: {
                                    AudioManager.shared.playUISound()
                                    withAnimation(.spring(response: 0.3)) {
                                        colorScheme = scheme
                                    }
                                }) {
                                    VStack(spacing: 8) {
                                        ZStack {
                                            Circle()
                                                .fill(
                                                    LinearGradient(
                                                        colors: scheme.particleColors.prefix(2).map { $0 },
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                                .frame(width: 40, height: 40)
                                            
                                            if colorScheme == scheme {
                                                Circle()
                                                    .stroke(Color.white, lineWidth: 3)
                                                    .frame(width: 48, height: 48)
                                            }
                                        }
                                        
                                        Text(scheme.rawValue)
                                            .font(.system(size: 11))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(
                                        colorScheme == scheme ?
                                        Color.white.opacity(0.1) : Color.clear
                                    )
                                    .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                        .padding(.horizontal, 20)
                    
                    // Controls Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Controls")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                            .textCase(.uppercase)
                            .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "gauge.medium")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                                Text("Speed")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                                Spacer()
                                Text(String(format: "%.1fx", speed))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            Slider(value: $speed, in: 0.1...3.0)
                                .tint(.white.opacity(0.7))
                        }
                        .padding(.horizontal, 20)
                        
                        if selectedVisualization == .particles {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "circle.grid.3x3.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.6))
                                    Text("Density")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.8))
                                    Spacer()
                                    Text("\(Int(density))")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                
                                Slider(value: $density, in: 20...300)
                                    .tint(.white.opacity(0.7))
                            }
                            .padding(.horizontal, 20)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                        
                        Divider()
                            .background(Color.white.opacity(0.2))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                        
                        // Sound control
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: audioManager.isEnabled ? "speaker.wave.2" : "speaker.slash")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                                Text("Sound")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                                Spacer()
                                Toggle("", isOn: $audioManager.isEnabled)
                                    .labelsHidden()
                                    .tint(.white.opacity(0.7))
                            }
                            
                            if audioManager.isEnabled {
                                HStack {
                                    Image(systemName: "speaker.wave.1")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.5))
                                    Text("Volume")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.6))
                                    Spacer()
                                    Text("\(Int(audioManager.volume * 100))%")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                
                                Slider(value: $audioManager.volume, in: 0.0...1.0)
                                    .tint(.white.opacity(0.7))
                                
                                .transition(.opacity.combined(with: .move(edge: .top)))
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.vertical, 8)
            }
        }
        .frame(maxWidth: 280)
        .background(
            ZStack {
                Color.black.opacity(0.3)
                    .background(.ultraThinMaterial)
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: colorScheme.particleColors.map { $0.opacity(0.1) },
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
        )
        .shadow(color: .black.opacity(0.5), radius: 30, x: 10, y: 0)
    }
    
    private func iconForVisualization(_ type: VisualizationType) -> String {
        switch type {
        case .particles:
            return "sparkles"
        case .sphere:
            return "globe"
        case .glassCards:
            return "square.stack.3d.up"
        case .waves:
            return "waveform"
        case .galaxy:
            return "circle.hexagongrid.fill"
        case .aurora:
            return "sparkle"
        }
    }
}
