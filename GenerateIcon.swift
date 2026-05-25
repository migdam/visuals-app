#!/usr/bin/env swift

import AppKit
import CoreGraphics

func generateIcon(size: CGSize) -> NSImage {
    let image = NSImage(size: size)
    image.lockFocus()
    
    guard let context = NSGraphicsContext.current?.cgContext else {
        image.unlockFocus()
        return image
    }
    
    // Background gradient (cosmic purple to blue)
    let gradient = NSGradient(colors: [
        NSColor(red: 0.2, green: 0.1, blue: 0.4, alpha: 1.0),
        NSColor(red: 0.1, green: 0.2, blue: 0.5, alpha: 1.0),
        NSColor(red: 0.05, green: 0.1, blue: 0.3, alpha: 1.0)
    ])!
    gradient.draw(in: NSRect(origin: .zero, size: size), angle: 135)
    
    // Draw glowing particles/spheres
    let particleCount = 30
    let centerX = size.width / 2
    let centerY = size.height / 2
    let radius = min(size.width, size.height) * 0.35
    
    for i in 0..<particleCount {
        let angle = Double(i) * 2.0 * .pi / Double(particleCount)
        let r = radius * (0.7 + 0.3 * sin(Double(i) * 0.5))
        
        let x = centerX + CGFloat(cos(angle)) * r
        let y = centerY + CGFloat(sin(angle)) * r
        
        // Particle glow
        let glowRadius: CGFloat = size.width * 0.025
        let colors = [
            NSColor(red: 0.4, green: 0.7, blue: 1.0, alpha: 0.8).cgColor,
            NSColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 0.6).cgColor,
            NSColor(red: 0.8, green: 0.5, blue: 1.0, alpha: 0.0).cgColor
        ]
        
        let glowGradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors as CFArray,
            locations: [0.0, 0.5, 1.0]
        )!
        
        context.drawRadialGradient(
            glowGradient,
            startCenter: CGPoint(x: x, y: y),
            startRadius: 0,
            endCenter: CGPoint(x: x, y: y),
            endRadius: glowRadius * 3,
            options: []
        )
        
        // Core particle
        context.setFillColor(NSColor(red: 1.0, green: 0.9, blue: 1.0, alpha: 1.0).cgColor)
        context.fillEllipse(in: CGRect(
            x: x - glowRadius * 0.5,
            y: y - glowRadius * 0.5,
            width: glowRadius,
            height: glowRadius
        ))
    }
    
    // Central glow
    let centralGlowColors = [
        NSColor(red: 1.0, green: 0.8, blue: 1.0, alpha: 0.5).cgColor,
        NSColor(red: 0.6, green: 0.4, blue: 1.0, alpha: 0.2).cgColor,
        NSColor(red: 0.4, green: 0.3, blue: 0.8, alpha: 0.0).cgColor
    ]
    
    let centralGradient = CGGradient(
        colorsSpace: CGColorSpaceCreateDeviceRGB(),
        colors: centralGlowColors as CFArray,
        locations: [0.0, 0.6, 1.0]
    )!
    
    context.drawRadialGradient(
        centralGradient,
        startCenter: CGPoint(x: centerX, y: centerY),
        startRadius: 0,
        endCenter: CGPoint(x: centerX, y: centerY),
        endRadius: radius * 0.8,
        options: []
    )
    
    image.unlockFocus()
    return image
}

func saveIconSet() {
    let sizes: [CGFloat] = [16, 32, 64, 128, 256, 512, 1024]
    let iconsetPath = "AppIcon.iconset"
    
    // Create iconset directory
    try? FileManager.default.createDirectory(atPath: iconsetPath, withIntermediateDirectories: true)
    
    for size in sizes {
        let image = generateIcon(size: CGSize(width: size, height: size))
        
        // Save 1x version
        if let tiffData = image.tiffRepresentation,
           let bitmap = NSBitmapImageRep(data: tiffData),
           let pngData = bitmap.representation(using: .png, properties: [:]) {
            let filename = "\(iconsetPath)/icon_\(Int(size))x\(Int(size)).png"
            try? pngData.write(to: URL(fileURLWithPath: filename))
            print("Generated: \(filename)")
        }
        
        // Save 2x version (Retina)
        if size <= 512 {
            let image2x = generateIcon(size: CGSize(width: size * 2, height: size * 2))
            if let tiffData = image2x.tiffRepresentation,
               let bitmap = NSBitmapImageRep(data: tiffData),
               let pngData = bitmap.representation(using: .png, properties: [:]) {
                let filename = "\(iconsetPath)/icon_\(Int(size))x\(Int(size))@2x.png"
                try? pngData.write(to: URL(fileURLWithPath: filename))
                print("Generated: \(filename)")
            }
        }
    }
    
    print("\nIconset created successfully!")
    print("Run: iconutil -c icns AppIcon.iconset")
}

saveIconSet()
