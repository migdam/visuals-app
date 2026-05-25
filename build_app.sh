#!/bin/bash

echo "Building Visuals.app with icon..."

# Compile the executable
swiftc -O -framework SwiftUI -framework Foundation -framework AppKit -framework AVFoundation \
  VisualsApp.swift ContentView.swift ImageDropView.swift SidebarView.swift AudioManager.swift ControlPanel.swift \
  ParticleSystemView.swift SphereView.swift GlassCardsView.swift WaveVisualizationView.swift \
  GalaxyView.swift AuroraView.swift -o Visuals

if [ $? -ne 0 ]; then
    echo "Compilation failed!"
    exit 1
fi

# Create app bundle structure
APP_NAME="Visuals.app"
rm -rf "$APP_NAME"
mkdir -p "$APP_NAME/Contents/MacOS"
mkdir -p "$APP_NAME/Contents/Resources"

# Copy executable
cp Visuals "$APP_NAME/Contents/MacOS/"

# Copy Info.plist
cp Info-macOS.plist "$APP_NAME/Contents/Info.plist"

# Copy icon
cp AppIcon.icns "$APP_NAME/Contents/Resources/"

echo "✓ Visuals.app created successfully with icon!"
echo "  Run: open Visuals.app"
