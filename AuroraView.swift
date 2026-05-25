//
//  AuroraView.swift
//  Visuals
//
//  Co-Authored-By: Oz <oz-agent@warp.dev>
//

import SwiftUI

struct AuroraView: View {
    let colorScheme: ColorSchemeType
    let speed: Double
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate * speed * 0.5
                let colors = colorScheme.particleColors
                
                // Draw multiple aurora bands
                for band in 0..<4 {
                    let bandOffset = Double(band) * 0.8
                    let verticalPosition = size.height * (0.2 + Double(band) * 0.15)
                    
                    var path = Path()
                    var controlPoints: [CGPoint] = []
                    
                    // Generate smooth curve points
                    for x in stride(from: -50, through: size.width + 50, by: 50) {
                        let wave1 = sin((x / 100) + time + bandOffset) * 60
                        let wave2 = cos((x / 80) + time * 1.3 + bandOffset) * 40
                        let wave3 = sin((x / 120) + time * 0.7 + bandOffset) * 30
                        
                        let y = verticalPosition + wave1 + wave2 + wave3
                        controlPoints.append(CGPoint(x: x, y: y))
                    }
                    
                    // Draw flowing ribbons using smooth curves
                    if controlPoints.count > 2 {
                        path.move(to: controlPoints[0])
                        
                        for i in 1..<controlPoints.count {
                            let current = controlPoints[i]
                            let previous = controlPoints[i - 1]
                            let control = CGPoint(
                                x: (current.x + previous.x) / 2,
                                y: (current.y + previous.y) / 2
                            )
                            path.addQuadCurve(to: current, control: control)
                        }
                        
                        // Create ribbon by drawing upper and lower bounds
                        for ribbonLayer in 0..<3 {
                            let ribbonHeight = 40.0 - Double(ribbonLayer) * 10
                            let ribbonAlpha = 0.15 - Double(ribbonLayer) * 0.04
                            
                            var ribbonPath = Path()
                            
                            // Upper curve
                            ribbonPath.move(to: CGPoint(
                                x: controlPoints[0].x,
                                y: controlPoints[0].y - ribbonHeight * 0.5
                            ))
                            
                            for i in 1..<controlPoints.count {
                                let current = controlPoints[i]
                                let previous = controlPoints[i - 1]
                                let control = CGPoint(
                                    x: (current.x + previous.x) / 2,
                                    y: (current.y + previous.y) / 2 - ribbonHeight * 0.5
                                )
                                ribbonPath.addQuadCurve(
                                    to: CGPoint(x: current.x, y: current.y - ribbonHeight * 0.5),
                                    control: control
                                )
                            }
                            
                            // Lower curve (reverse)
                            for i in (0..<controlPoints.count).reversed() {
                                let current = controlPoints[i]
                                ribbonPath.addLine(to: CGPoint(
                                    x: current.x,
                                    y: current.y + ribbonHeight * 0.5
                                ))
                            }
                            
                            ribbonPath.closeSubpath()
                            
                            // Fill with gradient
                            let color = colors[band % colors.count]
                            context.fill(
                                ribbonPath,
                                with: .color(color.opacity(ribbonAlpha))
                            )
                        }
                    }
                }
                
                // Add twinkling stars
                let starSeed = 12345
                for i in 0..<100 {
                    let pseudoRandom = Double((i * starSeed) % 10000) / 10000.0
                    let x = pseudoRandom * size.width
                    let y = (Double((i * starSeed * 7) % 10000) / 10000.0) * size.height * 0.7
                    
                    let twinkle = sin(time * 3 + Double(i)) * 0.5 + 0.5
                    let starSize = 2.0 + twinkle * 2
                    let alpha = 0.3 + twinkle * 0.4
                    
                    context.fill(
                        Circle().path(in: CGRect(
                            x: x - starSize * 0.5,
                            y: y - starSize * 0.5,
                            width: starSize,
                            height: starSize
                        )),
                        with: .color(.white.opacity(alpha))
                    )
                }
                
                // Add shooting rays
                for ray in 0..<5 {
                    let rayTime = time + Double(ray) * 1.2
                    let x = size.width * (0.2 + (sin(rayTime * 0.5) * 0.3 + 0.5) * 0.6)
                    let startY = size.height * 0.15
                    let endY = size.height * 0.7
                    
                    let rayAlpha = (sin(rayTime * 2) * 0.5 + 0.5) * 0.15
                    
                    var rayPath = Path()
                    rayPath.move(to: CGPoint(x: x, y: startY))
                    rayPath.addLine(to: CGPoint(x: x + 20, y: endY))
                    rayPath.addLine(to: CGPoint(x: x - 20, y: endY))
                    rayPath.closeSubpath()
                    
                    context.fill(
                        rayPath,
                        with: .color(colors[ray % colors.count].opacity(rayAlpha))
                    )
                }
            }
        }
    }
}
