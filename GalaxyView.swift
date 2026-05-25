//
//  GalaxyView.swift
//  Visuals
//
//  Co-Authored-By: Oz <oz-agent@warp.dev>
//

import SwiftUI

struct GalaxyView: View {
    let colorScheme: ColorSchemeType
    let speed: Double
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate * speed * 0.3
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let colors = colorScheme.particleColors
                
                // Draw spiral arms
                for arm in 0..<3 {
                    let armOffset = Double(arm) * .pi * 2 / 3
                    
                    for i in stride(from: 0, through: 200, by: 1) {
                        let t = Double(i) / 200.0
                        let angle = t * .pi * 6 + armOffset + time
                        let radius = t * min(size.width, size.height) * 0.45
                        
                        let x = center.x + cos(angle) * radius
                        let y = center.y + sin(angle) * radius
                        
                        let particleSize = (1 - t) * 8 + 2
                        let alpha = (1 - t) * 0.8
                        
                        let colorIndex = Int(t * Double(colors.count)) % colors.count
                        let color = colors[colorIndex]
                        
                        // Star glow
                        context.fill(
                            Circle().path(in: CGRect(
                                x: x - particleSize * 2,
                                y: y - particleSize * 2,
                                width: particleSize * 4,
                                height: particleSize * 4
                            )),
                            with: .color(color.opacity(alpha * 0.2))
                        )
                        
                        // Star core
                        context.fill(
                            Circle().path(in: CGRect(
                                x: x - particleSize * 0.5,
                                y: y - particleSize * 0.5,
                                width: particleSize,
                                height: particleSize
                            )),
                            with: .color(color.opacity(alpha))
                        )
                    }
                }
                
                // Draw center core
                let coreSize = 40.0
                let coreGlow = 80.0
                
                // Outer glow
                let gradient = Gradient(colors: [
                    colors[0].opacity(0.3),
                    colors[1].opacity(0.2),
                    colors[2].opacity(0.1),
                    .clear
                ])
                
                context.fill(
                    Circle().path(in: CGRect(
                        x: center.x - coreGlow,
                        y: center.y - coreGlow,
                        width: coreGlow * 2,
                        height: coreGlow * 2
                    )),
                    with: .radialGradient(
                        gradient,
                        center: center,
                        startRadius: 0,
                        endRadius: coreGlow
                    )
                )
                
                // Core
                context.fill(
                    Circle().path(in: CGRect(
                        x: center.x - coreSize * 0.5,
                        y: center.y - coreSize * 0.5,
                        width: coreSize,
                        height: coreSize
                    )),
                    with: .color(.white.opacity(0.8))
                )
                
                // Rotating halo
                for i in 0..<12 {
                    let angle = (Double(i) / 12.0) * .pi * 2 + time * 2
                    let radius = 60.0 + sin(time * 3 + Double(i)) * 10
                    let x = center.x + cos(angle) * radius
                    let y = center.y + sin(angle) * radius
                    let orbSize = 6.0
                    
                    context.fill(
                        Circle().path(in: CGRect(
                            x: x - orbSize * 0.5,
                            y: y - orbSize * 0.5,
                            width: orbSize,
                            height: orbSize
                        )),
                        with: .color(colors[i % colors.count].opacity(0.6))
                    )
                }
            }
        }
    }
}
