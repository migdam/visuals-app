//
//  WaveVisualizationView.swift
//  Visuals
//
//  Co-Authored-By: Oz <oz-agent@warp.dev>
//

import SwiftUI

struct WaveVisualizationView: View {
    let colorScheme: ColorSchemeType
    let speed: Double
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate * speed
                let colors = colorScheme.particleColors
                
                // Draw multiple wave layers
                for layer in 0..<5 {
                    let layerOffset = Double(layer) * 0.5
                    let amplitude = size.height * 0.08 * (1 + Double(layer) * 0.1)
                    let frequency = 0.015 - Double(layer) * 0.002
                    let verticalOffset = size.height * (0.3 + Double(layer) * 0.15)
                    
                    var path = Path()
                    path.move(to: CGPoint(x: 0, y: size.height))
                    
                    for x in stride(from: 0, through: size.width, by: 5) {
                        let wave1 = sin((x * frequency) + (time * 2) + layerOffset) * amplitude
                        let wave2 = sin((x * frequency * 1.5) + (time * 1.5) + layerOffset) * amplitude * 0.5
                        let wave3 = sin((x * frequency * 0.5) + (time * 2.5) + layerOffset) * amplitude * 0.3
                        
                        let y = verticalOffset + wave1 + wave2 + wave3
                        
                        if x == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                    
                    path.addLine(to: CGPoint(x: size.width, y: size.height))
                    path.addLine(to: CGPoint(x: 0, y: size.height))
                    path.closeSubpath()
                    
                    // Draw filled wave
                    let color = colors[layer % colors.count]
                    let opacity = 0.15 - Double(layer) * 0.02
                    
                    context.fill(
                        path,
                        with: .color(color.opacity(opacity))
                    )
                    
                    // Draw wave outline
                    var outlinePath = Path()
                    for x in stride(from: 0, through: size.width, by: 5) {
                        let wave1 = sin((x * frequency) + (time * 2) + layerOffset) * amplitude
                        let wave2 = sin((x * frequency * 1.5) + (time * 1.5) + layerOffset) * amplitude * 0.5
                        let wave3 = sin((x * frequency * 0.5) + (time * 2.5) + layerOffset) * amplitude * 0.3
                        
                        let y = verticalOffset + wave1 + wave2 + wave3
                        
                        if x == 0 {
                            outlinePath.move(to: CGPoint(x: x, y: y))
                        } else {
                            outlinePath.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                    
                    context.stroke(
                        outlinePath,
                        with: .color(color.opacity(0.4)),
                        lineWidth: 2
                    )
                }
                
                // Add floating orbs
                for i in 0..<8 {
                    let orbTime = time + Double(i) * 1.5
                    let x = size.width * 0.5 + cos(orbTime * 0.3 + Double(i)) * size.width * 0.3
                    let y = size.height * 0.5 + sin(orbTime * 0.4 + Double(i) * 0.7) * size.height * 0.25
                    let size = 20 + sin(orbTime * 2 + Double(i)) * 10
                    
                    let color = colors[i % colors.count]
                    
                    // Glow
                    context.fill(
                        Circle().path(in: CGRect(x: x - size * 1.5, y: y - size * 1.5, width: size * 3, height: size * 3)),
                        with: .color(color.opacity(0.1))
                    )
                    
                    // Orb
                    context.fill(
                        Circle().path(in: CGRect(x: x - size * 0.5, y: y - size * 0.5, width: size, height: size)),
                        with: .color(color.opacity(0.6))
                    )
                }
            }
        }
    }
}
