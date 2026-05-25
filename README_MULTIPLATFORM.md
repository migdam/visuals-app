# Visuals - Multiplatform Visualization App

A beautiful, modern SwiftUI app featuring stunning animated visualizations for **macOS**, **iOS**, and **iPadOS**.

## Features

🎨 **Five Unique Visualizations:**
- **Particles** - Flowing particle system with connections and glowing effects
- **3D Sphere** - 200 particles on a rotating 3D sphere with perspective projection
- **Waves** - Smooth, flowing wave animations with floating orbs
- **Galaxy** - Spiral galaxy with rotating stars and glowing core
- **Aurora** - Aurora borealis with flowing ribbons and twinkling stars

🎭 **Five Color Schemes:**
- Cosmic (purple, blue, pink, cyan)
- Ocean (cyan, blue, aqua)
- Sunset (orange, red, pink, yellow)
- Forest (green shades)
- Monochrome (white, grays)

⚡ **Interactive Controls:**
- Switch between visualizations
- Change color schemes
- Adjust animation speed (0.1x - 3.0x)
- Control particle density (for Particles view)
- Clean, modern UI with glassmorphism effects

📱 **Platform Support:**
- **macOS** 13.0+
- **iOS** 16.0+
- **iPadOS** 16.0+

## Requirements

### macOS
- macOS 13.0 or later
- Xcode 15.0 or later (for full Xcode build)
- Swift 5.9+ (for command line build)

### iOS/iPadOS
- iOS/iPadOS 16.0 or later
- Xcode 15.0 or later
- Apple Developer account (for device deployment)

## Building the App

### macOS

#### Option 1: Using Xcode
```bash
open Visuals.xcodeproj
```
Press `Cmd + R` to build and run

#### Option 2: Command Line (macOS only)
```bash
swiftc -O -framework SwiftUI -framework Foundation -framework AppKit \
  VisualsApp.swift ContentView.swift ControlPanel.swift \
  ParticleSystemView.swift SphereView.swift WaveVisualizationView.swift \
  GalaxyView.swift AuroraView.swift -o Visuals
./Visuals
```

### iOS/iPadOS

#### Using Xcode (Required for iOS)
```bash
open VisualsIOS.xcodeproj
```

1. Select **VisualsIOS** as the scheme
2. Choose your target:
   - **iPhone simulator** (e.g., iPhone 15 Pro)
   - **iPad simulator** (e.g., iPad Pro)
   - **Your physical device** (requires Apple Developer account)
3. Press `Cmd + R` to build and run

**Note:** iOS apps cannot be built from command line without Xcode due to code signing requirements.

## Usage

### macOS
1. Launch the app
2. Click "Show Controls" at the bottom to reveal the control panel
3. Select your preferred visualization
4. Choose a color scheme
5. Adjust speed and density to your liking
6. Click "Hide Controls" to enjoy the full visualization

### iOS/iPadOS
1. Launch the app (full-screen immersive experience)
2. Tap anywhere to reveal the control panel at the bottom
3. Swipe horizontally through visualization options
4. Tap color scheme circles to change themes
5. Use sliders to adjust speed and density
6. Tap "Hide Controls" or anywhere outside the panel to dismiss
7. All orientations supported (portrait and landscape)

## Architecture

The app uses modern SwiftUI features:
- `TimelineView` for smooth 60fps animations
- `Canvas` for high-performance drawing
- Cross-platform conditional compilation (`#if os(macOS)`, `#if os(iOS)`)
- SwiftUI animations and transitions
- Glassmorphism UI design
- Reactive state management
- 3D rotation matrices and perspective projection

## Platform-Specific Features

### macOS
- Hidden title bar for immersive experience
- Window chrome customization
- Keyboard shortcuts support

### iOS/iPadOS
- Edge-to-edge display with safe area handling
- Touch-optimized controls with horizontal scrolling
- Status bar hidden for full immersion
- Support for all device orientations
- Optimized for both iPhone and iPad screen sizes
- Adaptive layout for different screen densities

## Performance

All visualizations are GPU-accelerated and optimized for:
- Smooth 60fps animation on all platforms
- Low CPU usage
- Minimal memory footprint
- Energy efficiency (important for battery life on iOS/iPadOS)
- Retina/ProMotion display support

## File Structure

```
swift_app/
├── VisualsApp.swift              # macOS-only app entry point
├── VisualsMultiplatformApp.swift # iOS/iPadOS app entry point
├── ContentView.swift              # Main view (multiplatform)
├── ControlPanel.swift             # Control UI (multiplatform)
├── ParticleSystemView.swift       # 2D particles visualization
├── SphereView.swift               # 3D sphere visualization
├── WaveVisualizationView.swift    # Wave visualization
├── GalaxyView.swift               # Galaxy visualization
├── AuroraView.swift               # Aurora visualization
├── Assets.xcassets/               # Shared assets
├── Info.plist                     # iOS/iPadOS configuration
├── Visuals.entitlements           # macOS entitlements
├── Visuals.xcodeproj/             # macOS Xcode project
└── VisualsIOS.xcodeproj/          # iOS/iPadOS Xcode project
```

---

**Co-Authored-By:** Oz <oz-agent@warp.dev>
