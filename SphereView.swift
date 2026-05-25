//
//  SphereView.swift
//  Visuals
//
//  Co-Authored-By: Oz <oz-agent@warp.dev>
//

import SwiftUI

struct SphereView: View {
    let colorScheme: ColorSchemeType
    let speed: Double
    
    @State private var particles3D: [Particle3D] = []
    
    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let time = timeline.date.timeIntervalSinceReferenceDate * speed
                    let colors = colorScheme.particleColors
                    
                    // Initialize 3D particles if needed
                    if particles3D.isEmpty {
                        DispatchQueue.main.async {
                            particles3D = (0..<200).map { i in
                                // Fibonacci sphere distribution for even coverage
                                let goldenRatio = (1.0 + sqrt(5.0)) / 2.0
                                let idx = Double(i)
                                let theta = 2.0 * .pi * idx / goldenRatio
                                let phi = acos(1.0 - 2.0 * (idx + 0.5) / 200.0)
                                
                                let radius = 150.0
                                let x = radius * sin(phi) * cos(theta)
                                let y = radius * sin(phi) * sin(theta)
                                let z = radius * cos(phi)
                                
                                return Particle3D(
                                    x: x,
                                    y: y,
                                    z: z,
                                    baseX: x,
                                    baseY: y,
                                    baseZ: z,
                                    size: Double.random(in: 2...5),
                                    color: colors[i % colors.count],
                                    phase: Double.random(in: 0...(.pi * 2))
                                )
                            }
                        }
                    }
                    
                    let centerX = size.width / 2
                    let centerY = size.height / 2
                    
                    // Rotation matrices
                    let rotationY = time * 0.3
                    let rotationX = sin(time * 0.2) * 0.3
                    
                    // Transform and sort particles by depth
                    var transformedParticles: [(particle: Particle3D, screenX: Double, screenY: Double, depth: Double)] = []
                    
                    for particle in particles3D {
                        // Rotate around Y axis
                        var x = particle.baseX * cos(rotationY) + particle.baseZ * sin(rotationY)
                        var y = particle.baseY
                        var z = -particle.baseX * sin(rotationY) + particle.baseZ * cos(rotationY)
                        
                        // Rotate around X axis
                        let tempY = y
                        y = y * cos(rotationX) - z * sin(rotationX)
                        z = tempY * sin(rotationX) + z * cos(rotationX)
                        
                        // Perspective projection
                        let perspective = 800.0
                        let scale = perspective / (perspective + z)
                        
                        let screenX = centerX + x * scale
                        let screenY = centerY + y * scale
                        
                        transformedParticles.append((particle, screenX, screenY, z))
                    }
                    
                    // Sort by depth (back to front)
                    transformedParticles.sort { $0.depth < $1.depth }
                    
                    // Draw connections first (behind particles)
                    for i in 0..<transformedParticles.count {
                        let p1 = transformedParticles[i]
                        
                        // Only connect nearby particles
                        for j in (i + 1)..<min(i + 8, transformedParticles.count) {
                            let p2 = transformedParticles[j]
                            
                            let dx = p1.particle.baseX - p2.particle.baseX
                            let dy = p1.particle.baseY - p2.particle.baseY
                            let dz = p1.particle.baseZ - p2.particle.baseZ
                            let distance = sqrt(dx * dx + dy * dy + dz * dz)
                            
                            if distance < 80 {
                                let opacity = (1 - distance / 80) * 0.15
                                let avgDepth = (p1.depth + p2.depth) / 2
                                let depthOpacity = max(0.2, min(1.0, (avgDepth + 200) / 400))
                                
                                var path = Path()
                                path.move(to: CGPoint(x: p1.screenX, y: p1.screenY))
                                path.addLine(to: CGPoint(x: p2.screenX, y: p2.screenY))
                                
                                context.stroke(
                                    path,
                                    with: .color(.white.opacity(opacity * depthOpacity)),
                                    lineWidth: 0.8
                                )
                            }
                        }
                    }
                    
                    // Draw particles
                    for (particle, screenX, screenY, depth) in transformedParticles {
                        let perspective = 800.0
                        let scale = perspective / (perspective + depth)
                        let scaledSize = particle.size * scale
                        let pulseSize = scaledSize * (1 + 0.2 * sin(time * 2 + particle.phase))
                        
                        // Depth-based opacity and brightness
                        let depthFactor = max(0.3, min(1.0, (depth + 200) / 400))
                        
                        // Outer glow
                        context.fill(
                            Circle().path(in: CGRect(
                                x: screenX - pulseSize * 2.5,
                                y: screenY - pulseSize * 2.5,
                                width: pulseSize * 5,
                                height: pulseSize * 5
                            )),
                            with: .color(particle.color.opacity(0.15 * depthFactor))
                        )
                        
                        // Inner glow
                        context.fill(
                            Circle().path(in: CGRect(
                                x: screenX - pulseSize * 1.2,
                                y: screenY - pulseSize * 1.2,
                                width: pulseSize * 2.4,
                                height: pulseSize * 2.4
                            )),
                            with: .color(particle.color.opacity(0.5 * depthFactor))
                        )
                        
                        // Core
                        context.fill(
                            Circle().path(in: CGRect(
                                x: screenX - pulseSize * 0.5,
                                y: screenY - pulseSize * 0.5,
                                width: pulseSize,
                                height: pulseSize
                            )),
                            with: .color(particle.color.opacity(0.9 * depthFactor))
                        )
                    }
                    
                    // Draw center point
                    let centerSize = 15.0 + sin(time * 2) * 5
                    context.fill(
                        Circle().path(in: CGRect(
                            x: centerX - centerSize * 0.5,
                            y: centerY - centerSize * 0.5,
                            width: centerSize,
                            height: centerSize
                        )),
                        with: .color(.white.opacity(0.3))
                    )
                }
            }
        }
    }
}

struct Particle3D {
    var x: Double
    var y: Double
    var z: Double
    let baseX: Double
    let baseY: Double
    let baseZ: Double
    var size: Double
    var color: Color
    var phase: Double
}
