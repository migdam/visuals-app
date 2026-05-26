# Visuals

A modern, beautiful visualization app for macOS with immersive audio and drag-and-drop image support.

## Features

### 6 Stunning Visualizations
- **Particles**: Dynamic particle system with connection lines
- **3D Sphere**: Rotating 3D particle sphere with depth sorting
- **Glass Cards**: Animated glassmorphism cards with floating particles
- **Waves**: Layered wave animations
- **Galaxy**: Spiral galaxy with rotating stars
- **Aurora**: Aurora borealis with flowing ribbons

### 5 Color Schemes
- **Cosmic**: Purple and blue space theme
- **Ocean**: Cyan and deep blue
- **Sunset**: Orange, red, and pink
- **Forest**: Green nature tones
- **Monochrome**: Black, white, and grays

### Audio System
- **Ambient Tones**: Unique frequency for each visualization (136Hz - 432Hz)
- **Generative Melody**: Pentatonic scale with ADSR envelope
- **System Sounds**: UI feedback for interactions
- **Volume Control**: Adjustable volume with toggle
- **Auto-cleanup**: Audio stops properly when app quits

### Drag & Drop
- Drop any image onto the window to overlay it
- Adjustable opacity (0-100%)
- Screen blend mode for beautiful effects
- Visual drop indicator
- Clear button to remove image

### UI
- Unified sidebar navigation with icons
- Swipe gestures (macOS and iOS)
- Glassmorphism design
- Smooth spring animations
- Custom app icon

## Requirements

- macOS 13.0+ (for macOS app)
- iOS/iPadOS 16.0+ (for mobile app)
- Xcode 14.0+ (for development)
- Swift 5.7+

## Building

### Quick Build
```bash
./build_app.sh
open Visuals.app
```

### Manual Build
```bash
swiftc -O -framework SwiftUI -framework Foundation -framework AppKit -framework AVFoundation \
  VisualsApp.swift ContentView.swift SidebarView.swift AudioManager.swift ControlPanel.swift \
  ParticleSystemView.swift SphereView.swift GlassCardsView.swift WaveVisualizationView.swift \
  GalaxyView.swift AuroraView.swift -o Visuals
```

### Generate Icon
```bash
swift GenerateIcon.swift
iconutil -c icns AppIcon.iconset
```

## Testing

The project includes comprehensive unit tests covering:

### Drag and Drop Tests
- Initial state validation
- Image opacity range (0.0 - 1.0)
- Drop indicator visibility
- Image clear functionality
- Image format support

### Visualization Tests
- All 6 visualization types present
- Correct display names
- Switching between visualizations

### Color Scheme Tests
- All 5 schemes available
- Background colors defined
- Particle colors defined

### State Management Tests
- Sidebar toggle
- Speed control
- Density control
- Integration between features

### Running Tests
Tests use XCTest framework and can be run using:
```bash
swift test
```

Or through Xcode:
```bash
xcodebuild test -scheme Visuals
```

## Python Management Script

The project includes `manage_visuals.py` - a comprehensive file operations utility for managing the Visuals app.

### Installation
No installation needed. The script uses Python 3 standard library.

### Usage
```bash
python3 manage_visuals.py [command]
```

### Available Commands

#### Show App Information
```bash
python3 manage_visuals.py info
```
Displays app bundle size, executable size, icon size, and file paths.

#### List Source Files
```bash
python3 manage_visuals.py sources
```
Lists all Swift source files with line counts and sizes.

#### Create Backup
```bash
python3 manage_visuals.py backup
```
Creates a timestamped backup of Visuals.app in the `backups/` directory.

#### Export Project Structure
```bash
python3 manage_visuals.py export
```
Exports complete project structure to `project_structure.json` including:
- App bundle information
- Source file details
- Additional project files
- Generation timestamp

#### Clean Build Artifacts
```bash
python3 manage_visuals.py clean
```
Removes build artifacts:
- Standalone executable
- .DS_Store files
- AppIcon.iconset directory

#### Create Distribution Package
```bash
python3 manage_visuals.py dist
```
Creates a distribution package in `dist/` directory containing:
- Visuals.app bundle
- README.md documentation

#### Generate Statistics Report
```bash
python3 manage_visuals.py stats
```
Displays comprehensive statistics:
- Number of source files
- Total lines of code
- Source code size
- App bundle size
- Executable size
- Icon size

### Example Output
```bash
$ python3 manage_visuals.py stats

=== Statistics Report ===
Source Files: 15
Total Lines: 2516
Source Size: 99.62 KB

App Bundle: 2.57 MB
Executable: 870.04 KB
Icon: 1.72 MB
```

## Project Structure

```
swift_app/
├── VisualsApp.swift          # macOS app entry point
├── VisualsMultiplatformApp.swift  # iOS/iPadOS entry point
├── ContentView.swift          # Main view with drag & drop
├── SidebarView.swift          # Navigation sidebar
├── ImageDropView.swift        # Native drag & drop handler
├── AudioManager.swift         # Audio system (tones + melody)
├── ControlPanel.swift         # Legacy control panel
├── ParticleSystemView.swift   # Particle visualization
├── SphereView.swift          # 3D sphere visualization
├── GlassCardsView.swift      # Glass cards visualization
├── WaveVisualizationView.swift # Wave visualization
├── GalaxyView.swift          # Galaxy visualization
├── AuroraView.swift          # Aurora visualization
├── VisualsTests.swift        # Unit tests
├── GenerateIcon.swift        # Icon generator script
├── manage_visuals.py         # Python management utility
├── build_app.sh              # Build script
├── Info-macOS.plist          # macOS app configuration
├── Info.plist                # iOS/iPadOS configuration
├── AppIcon.icns              # App icon
└── README.md                 # This file
```

## Technical Details

### Audio Frequencies
- Particles: 220 Hz (A3)
- Sphere: 174 Hz (F3)
- Glass Cards: 432 Hz (A4)
- Waves: 136 Hz (C#3)
- Galaxy: 256 Hz (C4)
- Aurora: 396 Hz (G4)

### Melody System
- Pentatonic scale ratios: [1.0, 9/8, 5/4, 3/2, 5/3]
- Notes play every 2.5 seconds
- ADSR envelope: Attack 0.1s, Decay 0.2s, Sustain 0.5, Release 0.2s
- Octave shifts for variation
- 5Hz vibrato for organic sound

### Performance
- 60 FPS target for all visualizations
- GPU-accelerated rendering
- Efficient particle systems
- Optimized 3D calculations

## Development Workflow

### Making Changes
1. Edit Swift source files
2. Run `./build_app.sh` to rebuild
3. Test with `open Visuals.app`
4. Run `python3 manage_visuals.py stats` to see code metrics
5. Commit changes with proper co-author attribution

### Creating Releases
1. Update version in `Info-macOS.plist`
2. Build the app: `./build_app.sh`
3. Create backup: `python3 manage_visuals.py backup`
4. Create distribution: `python3 manage_visuals.py dist`
5. Test the distribution package
6. Tag release in git

### File Operations
Use the Python management script for common tasks:
- Check project health: `python3 manage_visuals.py stats`
- Create backups before major changes: `python3 manage_visuals.py backup`
- Export documentation: `python3 manage_visuals.py export`
- Clean up before commits: `python3 manage_visuals.py clean`

## Repository

- **GitHub**: https://github.com/migdam/visuals-app
- **Issues**: Report bugs or request features on GitHub Issues
- **Pull Requests**: Contributions welcome!

## License

---

**Co-Authored-By:** Oz <oz-agent@warp.dev>
