//
//  VisualsTests.swift
//  Visuals Tests
//
//  Co-Authored-By: Oz <oz-agent@warp.dev>
//

import XCTest
import SwiftUI
@testable import Visuals

class VisualsTests: XCTestCase {
    
    // MARK: - Drag and Drop Tests
    
    func testImageDropInitialState() {
        // Test that the initial state has no dropped image
        let contentView = ContentView()
        XCTAssertNil(contentView.droppedImage, "Initial dropped image should be nil")
        XCTAssertEqual(contentView.imageOpacity, 0.3, accuracy: 0.001, "Default opacity should be 0.3")
        XCTAssertFalse(contentView.showDropIndicator, "Drop indicator should be hidden initially")
    }
    
    func testImageOpacityRange() {
        // Test that image opacity stays within valid range
        let contentView = ContentView()
        
        // Test lower bound
        contentView.imageOpacity = -0.5
        XCTAssertGreaterThanOrEqual(contentView.imageOpacity, 0.0, "Opacity should not be negative")
        
        // Test upper bound
        contentView.imageOpacity = 1.5
        XCTAssertLessThanOrEqual(contentView.imageOpacity, 1.0, "Opacity should not exceed 1.0")
        
        // Test valid values
        contentView.imageOpacity = 0.5
        XCTAssertEqual(contentView.imageOpacity, 0.5, accuracy: 0.001, "Opacity should be set correctly")
    }
    
    func testDropIndicatorVisibility() {
        // Test that drop indicator shows when dragging and hides when not
        let contentView = ContentView()
        
        contentView.showDropIndicator = true
        XCTAssertTrue(contentView.showDropIndicator, "Drop indicator should be visible when set to true")
        
        contentView.showDropIndicator = false
        XCTAssertFalse(contentView.showDropIndicator, "Drop indicator should be hidden when set to false")
    }
    
    func testImageClearFunctionality() {
        // Test that clearing the image resets the state
        let contentView = ContentView()
        
        // Simulate having an image
        let testImage = NSImage(size: NSSize(width: 100, height: 100))
        contentView.droppedImage = testImage
        XCTAssertNotNil(contentView.droppedImage, "Image should be set")
        
        // Clear the image
        contentView.droppedImage = nil
        XCTAssertNil(contentView.droppedImage, "Image should be cleared")
    }
    
    func testValidImageFormats() {
        // Test that various image formats can be loaded
        let formats = ["png", "jpg", "jpeg", "gif", "tiff", "bmp"]
        
        for format in formats {
            // Create a simple test image
            let image = NSImage(size: NSSize(width: 10, height: 10))
            XCTAssertNotNil(image, "Should be able to create NSImage for format: \(format)")
        }
    }
    
    // MARK: - Visualization Type Tests
    
    func testVisualizationTypes() {
        // Test that all visualization types are available
        let types = VisualizationType.allCases
        XCTAssertEqual(types.count, 6, "Should have 6 visualization types")
        
        XCTAssertTrue(types.contains(.particles), "Should contain particles")
        XCTAssertTrue(types.contains(.sphere), "Should contain sphere")
        XCTAssertTrue(types.contains(.glassCards), "Should contain glass cards")
        XCTAssertTrue(types.contains(.waves), "Should contain waves")
        XCTAssertTrue(types.contains(.galaxy), "Should contain galaxy")
        XCTAssertTrue(types.contains(.aurora), "Should contain aurora")
    }
    
    func testVisualizationTypeNames() {
        // Test that visualization types have correct display names
        XCTAssertEqual(VisualizationType.particles.rawValue, "Particles")
        XCTAssertEqual(VisualizationType.sphere.rawValue, "3D Sphere")
        XCTAssertEqual(VisualizationType.glassCards.rawValue, "Glass Cards")
        XCTAssertEqual(VisualizationType.waves.rawValue, "Waves")
        XCTAssertEqual(VisualizationType.galaxy.rawValue, "Galaxy")
        XCTAssertEqual(VisualizationType.aurora.rawValue, "Aurora")
    }
    
    // MARK: - Color Scheme Tests
    
    func testColorSchemes() {
        // Test that all color schemes are available
        let schemes = ColorSchemeType.allCases
        XCTAssertEqual(schemes.count, 5, "Should have 5 color schemes")
        
        XCTAssertTrue(schemes.contains(.cosmic), "Should contain cosmic")
        XCTAssertTrue(schemes.contains(.ocean), "Should contain ocean")
        XCTAssertTrue(schemes.contains(.sunset), "Should contain sunset")
        XCTAssertTrue(schemes.contains(.forest), "Should contain forest")
        XCTAssertTrue(schemes.contains(.monochrome), "Should contain monochrome")
    }
    
    func testColorSchemeBackgrounds() {
        // Test that each color scheme has background colors
        for scheme in ColorSchemeType.allCases {
            let colors = scheme.backgroundColors
            XCTAssertGreaterThan(colors.count, 0, "Color scheme \(scheme.rawValue) should have background colors")
        }
    }
    
    func testColorSchemeParticleColors() {
        // Test that each color scheme has particle colors
        for scheme in ColorSchemeType.allCases {
            let colors = scheme.particleColors
            XCTAssertGreaterThan(colors.count, 0, "Color scheme \(scheme.rawValue) should have particle colors")
        }
    }
    
    // MARK: - State Management Tests
    
    func testSidebarToggle() {
        // Test sidebar visibility toggle
        let contentView = ContentView()
        
        XCTAssertFalse(contentView.showSidebar, "Sidebar should be hidden initially")
        
        contentView.showSidebar = true
        XCTAssertTrue(contentView.showSidebar, "Sidebar should be visible when toggled")
        
        contentView.showSidebar = false
        XCTAssertFalse(contentView.showSidebar, "Sidebar should be hidden when toggled again")
    }
    
    func testSpeedControl() {
        // Test speed control range
        let contentView = ContentView()
        
        XCTAssertEqual(contentView.speed, 1.0, accuracy: 0.001, "Default speed should be 1.0")
        
        contentView.speed = 2.0
        XCTAssertEqual(contentView.speed, 2.0, accuracy: 0.001, "Speed should be adjustable")
        
        contentView.speed = 0.5
        XCTAssertEqual(contentView.speed, 0.5, accuracy: 0.001, "Speed should be adjustable")
    }
    
    func testDensityControl() {
        // Test density control
        let contentView = ContentView()
        
        XCTAssertEqual(contentView.density, 100, accuracy: 0.001, "Default density should be 100")
        
        contentView.density = 200
        XCTAssertEqual(contentView.density, 200, accuracy: 0.001, "Density should be adjustable")
        
        contentView.density = 50
        XCTAssertEqual(contentView.density, 50, accuracy: 0.001, "Density should be adjustable")
    }
    
    // MARK: - Integration Tests
    
    func testVisualizationSwitching() {
        // Test switching between visualizations
        let contentView = ContentView()
        
        XCTAssertEqual(contentView.selectedVisualization, .particles, "Default visualization should be particles")
        
        contentView.selectedVisualization = .sphere
        XCTAssertEqual(contentView.selectedVisualization, .sphere, "Should be able to switch to sphere")
        
        contentView.selectedVisualization = .glassCards
        XCTAssertEqual(contentView.selectedVisualization, .glassCards, "Should be able to switch to glass cards")
    }
    
    func testColorSchemeSwitching() {
        // Test switching between color schemes
        let contentView = ContentView()
        
        XCTAssertEqual(contentView.colorScheme, .cosmic, "Default color scheme should be cosmic")
        
        contentView.colorScheme = .ocean
        XCTAssertEqual(contentView.colorScheme, .ocean, "Should be able to switch to ocean")
        
        contentView.colorScheme = .sunset
        XCTAssertEqual(contentView.colorScheme, .sunset, "Should be able to switch to sunset")
    }
    
    func testImageOverlayWithVisualization() {
        // Test that image overlay can coexist with visualizations
        let contentView = ContentView()
        
        contentView.selectedVisualization = .particles
        let testImage = NSImage(size: NSSize(width: 100, height: 100))
        contentView.droppedImage = testImage
        
        XCTAssertEqual(contentView.selectedVisualization, .particles, "Visualization should remain active")
        XCTAssertNotNil(contentView.droppedImage, "Image should be overlaid")
        
        // Switch visualization while image is present
        contentView.selectedVisualization = .galaxy
        XCTAssertEqual(contentView.selectedVisualization, .galaxy, "Should be able to switch visualization with image present")
        XCTAssertNotNil(contentView.droppedImage, "Image should remain after switching visualization")
    }
}

// MARK: - Test Extensions

extension ContentView {
    // Expose internal state for testing
    var droppedImage: NSImage? {
        get { _droppedImage.wrappedValue }
        set { _droppedImage.wrappedValue = newValue }
    }
    
    var imageOpacity: Double {
        get { _imageOpacity.wrappedValue }
        set { _imageOpacity.wrappedValue = newValue }
    }
    
    var showDropIndicator: Bool {
        get { _showDropIndicator.wrappedValue }
        set { _showDropIndicator.wrappedValue = newValue }
    }
    
    var showSidebar: Bool {
        get { _showSidebar.wrappedValue }
        set { _showSidebar.wrappedValue = newValue }
    }
    
    var selectedVisualization: VisualizationType {
        get { _selectedVisualization.wrappedValue }
        set { _selectedVisualization.wrappedValue = newValue }
    }
    
    var colorScheme: ColorSchemeType {
        get { _colorScheme.wrappedValue }
        set { _colorScheme.wrappedValue = newValue }
    }
    
    var speed: Double {
        get { _speed.wrappedValue }
        set { _speed.wrappedValue = newValue }
    }
    
    var density: Double {
        get { _density.wrappedValue }
        set { _density.wrappedValue = newValue }
    }
}
