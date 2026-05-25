//
//  GlassCardsView.swift
//  Visuals
//
//  Co-Authored-By: Oz <oz-agent@warp.dev>
//

import SwiftUI

struct GlassCardsView: View {
    let colorScheme: ColorSchemeType
    let speed: Double
    
    @State private var cards: [GlassCard] = []
    
    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let time = timeline.date.timeIntervalSinceReferenceDate * speed
                    let colors = colorScheme.particleColors
                    
                    // Initialize cards if needed
                    if cards.isEmpty {
                        DispatchQueue.main.async {
                            cards = (0..<12).map { i in
                                let angle = Double(i) * .pi * 2 / 12
                                let radius = min(size.width, size.height) * 0.3
                                
                                return GlassCard(
                                    x: size.width / 2 + cos(angle) * radius,
                                    y: size.height / 2 + sin(angle) * radius,
                                    width: Double.random(in: 150...250),
                                    height: Double.random(in: 200...300),
                                    rotation: Double.random(in: -0.2...0.2),
                                    speed: Double.random(in: 0.5...1.5),
                                    color: colors[i % colors.count],
                                    phase: Double(i) * .pi / 6
                                )
                            }
                        }
                    }
                    
                    // Draw connection lines between nearby cards
                    for i in 0..<cards.count {
                        for j in (i + 1)..<cards.count {
                            let dx = cards[i].x - cards[j].x
                            let dy = cards[i].y - cards[j].y
                            let distance = sqrt(dx * dx + dy * dy)
                            
                            if distance < 300 {
                                let opacity = (1 - distance / 300) * 0.15
                                var path = Path()
                                path.move(to: CGPoint(x: cards[i].x, y: cards[i].y))
                                path.addLine(to: CGPoint(x: cards[j].x, y: cards[j].y))
                                
                                context.stroke(
                                    path,
                                    with: .color(.white.opacity(opacity)),
                                    lineWidth: 1
                                )
                            }
                        }
                    }
                    
                    // Draw glass cards
                    for (index, card) in cards.enumerated() {
                        let cardTime = time * card.speed + card.phase
                        
                        // Calculate floating position
                        let floatX = card.x + sin(cardTime * 0.5) * 40
                        let floatY = card.y + cos(cardTime * 0.7) * 30
                        let floatRotation = card.rotation + sin(cardTime * 0.3) * 0.1
                        let scale = 0.9 + sin(cardTime) * 0.1
                        
                        let scaledWidth = card.width * scale
                        let scaledHeight = card.height * scale
                        
                        // Transform context for rotation
                        var cardContext = context
                        cardContext.translateBy(x: floatX, y: floatY)
                        cardContext.rotate(by: Angle(radians: floatRotation))
                        
                        let cardRect = CGRect(
                            x: -scaledWidth / 2,
                            y: -scaledHeight / 2,
                            width: scaledWidth,
                            height: scaledHeight
                        )
                        
                        // Shadow
                        let shadowPath = RoundedRectangle(cornerRadius: 20)
                            .path(in: cardRect.offsetBy(dx: 0, dy: 10))
                        cardContext.fill(
                            shadowPath,
                            with: .color(.black.opacity(0.3))
                        )
                        cardContext.addFilter(.blur(radius: 15))
                        
                        // Glass card background
                        let cardPath = RoundedRectangle(cornerRadius: 20).path(in: cardRect)
                        
                        // Gradient fill
                        let gradient = Gradient(colors: [
                            card.color.opacity(0.3),
                            card.color.opacity(0.15)
                        ])
                        cardContext.fill(
                            cardPath,
                            with: .linearGradient(
                                gradient,
                                startPoint: CGPoint(x: cardRect.minX, y: cardRect.minY),
                                endPoint: CGPoint(x: cardRect.maxX, y: cardRect.maxY)
                            )
                        )
                        
                        // Glass border/highlight
                        cardContext.stroke(
                            cardPath,
                            with: .color(.white.opacity(0.4)),
                            lineWidth: 2
                        )
                        
                        // Inner shine effect
                        let shinePath = RoundedRectangle(cornerRadius: 18)
                            .path(in: cardRect.insetBy(dx: 8, dy: 8))
                        let shineGradient = Gradient(colors: [
                            .white.opacity(0.3),
                            .clear
                        ])
                        cardContext.stroke(
                            shinePath,
                            with: .linearGradient(
                                shineGradient,
                                startPoint: CGPoint(x: cardRect.minX, y: cardRect.minY),
                                endPoint: CGPoint(x: cardRect.midX, y: cardRect.midY)
                            ),
                            lineWidth: 1.5
                        )
                        
                        // Animated light reflection
                        let reflectionX = sin(cardTime * 2) * scaledWidth * 0.3
                        let reflectionY = cos(cardTime * 1.5) * scaledHeight * 0.3
                        
                        let reflectionPath = Circle()
                            .path(in: CGRect(
                                x: reflectionX - 40,
                                y: reflectionY - 40,
                                width: 80,
                                height: 80
                            ))
                        
                        cardContext.fill(
                            reflectionPath,
                            with: .radialGradient(
                                Gradient(colors: [
                                    .white.opacity(0.4),
                                    .clear
                                ]),
                                center: CGPoint(x: reflectionX, y: reflectionY),
                                startRadius: 0,
                                endRadius: 60
                            )
                        )
                        
                        // Floating particles inside card
                        for p in 0..<8 {
                            let particlePhase = cardTime + Double(p) * .pi / 4
                            let px = sin(particlePhase * 1.3) * scaledWidth * 0.3
                            let py = cos(particlePhase * 0.9) * scaledHeight * 0.3
                            let particleSize = 4.0 + sin(particlePhase * 2) * 2
                            
                            let particlePath = Circle()
                                .path(in: CGRect(
                                    x: px - particleSize / 2,
                                    y: py - particleSize / 2,
                                    width: particleSize,
                                    height: particleSize
                                ))
                            
                            cardContext.fill(
                                particlePath,
                                with: .color(.white.opacity(0.6))
                            )
                        }
                    }
                    
                    // Central glow
                    let centerX = size.width / 2
                    let centerY = size.height / 2
                    let glowSize = 100 + sin(time * 2) * 20
                    
                    let centerGlow = Circle()
                        .path(in: CGRect(
                            x: centerX - glowSize / 2,
                            y: centerY - glowSize / 2,
                            width: glowSize,
                            height: glowSize
                        ))
                    
                    context.fill(
                        centerGlow,
                        with: .radialGradient(
                            Gradient(colors: [
                                .white.opacity(0.3),
                                .clear
                            ]),
                            center: CGPoint(x: centerX, y: centerY),
                            startRadius: 0,
                            endRadius: glowSize / 2
                        )
                    )
                }
            }
        }
    }
}

struct GlassCard {
    let x: Double
    let y: Double
    let width: Double
    let height: Double
    let rotation: Double
    let speed: Double
    let color: Color
    let phase: Double
}
