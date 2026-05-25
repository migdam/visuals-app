//
//  ParticleSystemView.swift
//  Visuals
//
//  Co-Authored-By: Oz <oz-agent@warp.dev>
//

import SwiftUI

struct ParticleSystemView: View {
    let colorScheme: ColorSchemeType
    let speed: Double
    let density: Int
    
    @State private var particles: [Particle] = []
    @State private var time: Double = 0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let currentTime = timeline.date.timeIntervalSinceReferenceDate * speed
                
                // Update particles
                if particles.count != density {
                    particles = (0..<density).map { _ in
                        Particle(
                            x: Double.random(in: 0...size.width),
                            y: Double.random(in: 0...size.height),
                            vx: Double.random(in: -1...1),
                            vy: Double.random(in: -1...1),
                            size: Double.random(in: 2...6),
                            color: colorScheme.particleColors.randomElement() ?? .white,
                            phase: Double.random(in: 0...(.pi * 2))
                        )
                    }
                }
                
                for (index, var particle) in particles.enumerated() {
                    // Update position
                    particle.x += particle.vx * speed
                    particle.y += particle.vy * speed
                    
                    // Wrap around edges
                    if particle.x < 0 { particle.x = size.width }
                    if particle.x > size.width { particle.x = 0 }
                    if particle.y < 0 { particle.y = size.height }
                    if particle.y > size.height { particle.y = 0 }
                    
                    particles[index] = particle
                    
                    // Draw particle with glow
                    let position = CGPoint(x: particle.x, y: particle.y)
                    let pulseSize = particle.size * (1 + 0.3 * sin(currentTime * 2 + particle.phase))
                    
                    // Outer glow
                    context.fill(
                        Circle().path(in: CGRect(
                            x: position.x - pulseSize * 2,
                            y: position.y - pulseSize * 2,
                            width: pulseSize * 4,
                            height: pulseSize * 4
                        )),
                        with: .color(particle.color.opacity(0.1))
                    )
                    
                    // Inner glow
                    context.fill(
                        Circle().path(in: CGRect(
                            x: position.x - pulseSize,
                            y: position.y - pulseSize,
                            width: pulseSize * 2,
                            height: pulseSize * 2
                        )),
                        with: .color(particle.color.opacity(0.4))
                    )
                    
                    // Core
                    context.fill(
                        Circle().path(in: CGRect(
                            x: position.x - pulseSize * 0.5,
                            y: position.y - pulseSize * 0.5,
                            width: pulseSize,
                            height: pulseSize
                        )),
                        with: .color(particle.color)
                    )
                }
                
                // Draw connections between nearby particles
                for i in 0..<particles.count {
                    for j in (i + 1)..<min(i + 10, particles.count) {
                        let dx = particles[i].x - particles[j].x
                        let dy = particles[i].y - particles[j].y
                        let distance = sqrt(dx * dx + dy * dy)
                        
                        if distance < 100 {
                            let opacity = (1 - distance / 100) * 0.2
                            var path = Path()
                            path.move(to: CGPoint(x: particles[i].x, y: particles[i].y))
                            path.addLine(to: CGPoint(x: particles[j].x, y: particles[j].y))
                            
                            context.stroke(
                                path,
                                with: .color(.white.opacity(opacity)),
                                lineWidth: 1
                            )
                        }
                    }
                }
            }
        }
    }
}

struct Particle {
    var x: Double
    var y: Double
    var vx: Double
    var vy: Double
    var size: Double
    var color: Color
    var phase: Double
}
