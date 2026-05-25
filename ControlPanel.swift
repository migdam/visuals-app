//
//  ControlPanel.swift
//  Visuals
//
//  Co-Authored-By: Oz <oz-agent@warp.dev>
//

import SwiftUI

struct ControlPanel: View {
    @Binding var selectedVisualization: VisualizationType
    @Binding var colorScheme: ColorSchemeType
    @Binding var speed: Double
    @Binding var density: Double
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            if isExpanded {
                VStack(alignment: .leading, spacing: 20) {
                    // Visualization selector
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Visualization")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(VisualizationType.allCases, id: \.self) { type in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedVisualization = type
                                        }
                                    }) {
                                        Text(type.rawValue)
                                            .font(.system(size: 12, weight: .medium))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                selectedVisualization == type ?
                                                Color.white.opacity(0.2) :
                                                Color.white.opacity(0.05)
                                            )
                                            .cornerRadius(8)
                                            .foregroundColor(.white)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                    
                    // Color scheme selector
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Color Scheme")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                        
                        HStack(spacing: 8) {
                            ForEach(ColorSchemeType.allCases, id: \.self) { scheme in
                                Button(action: {
                                    withAnimation(.spring(response: 0.3)) {
                                        colorScheme = scheme
                                    }
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: scheme.particleColors.prefix(2).map { $0 },
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 24, height: 24)
                                        
                                        if colorScheme == scheme {
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                                .frame(width: 30, height: 30)
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    // Speed control
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Speed")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                            Spacer()
                            Text(String(format: "%.1fx", speed))
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Slider(value: $speed, in: 0.1...3.0)
                            .tint(.white.opacity(0.7))
                    }
                    
                    // Density control (for particles)
                    if selectedVisualization == .particles {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Density")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                                Spacer()
                                Text("\(Int(density))")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            Slider(value: $density, in: 20...300)
                                .tint(.white.opacity(0.7))
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .padding(20)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Toggle button
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: isExpanded ? "chevron.down" : "slider.horizontal.3")
                        .font(.system(size: 14))
                    Text(isExpanded ? "Hide Controls" : "Show Controls")
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
        }
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}
