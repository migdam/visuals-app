# Visuals - Modern macOS Visualization App

A beautiful, modern SwiftUI app for macOS featuring stunning animated visualizations.

## Features

🎨 **Four Unique Visualizations:**
- **Particles** - Flowing particle system with connections and glowing effects
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
- Control particle density
- Clean, modern UI with glassmorphism effects

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later

## Building the App

### Option 1: Using Xcode (Recommended)

1. Open the project in Xcode:
   ```bash
   open Visuals.xcodeproj
   ```

2. Select the Visuals target and your Mac as the destination

3. Press `Cmd + R` to build and run

### Option 2: Using Command Line

Build the app from the command line:

```bash
xcodebuild -project Visuals.xcodeproj -scheme Visuals -configuration Release build
```

The built app will be located in the DerivedData directory.

## Usage

1. Launch the app
2. Click "Show Controls" at the bottom to reveal the control panel
3. Select your preferred visualization
4. Choose a color scheme
5. Adjust speed and density to your liking
6. Click "Hide Controls" to enjoy the full visualization

## Architecture

The app uses modern SwiftUI features:
- `TimelineView` for smooth 60fps animations
- `Canvas` for high-performance drawing
- SwiftUI animations and transitions
- Glassmorphism UI design
- Reactive state management

## Performance

All visualizations are GPU-accelerated and optimized for:
- Smooth 60fps animation
- Low CPU usage
- Minimal memory footprint
- Energy efficiency

---

**Co-Authored-By:** Oz <oz-agent@warp.dev>
