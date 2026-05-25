//
//  ImageDropView.swift
//  Visuals
//
//  Co-Authored-By: Oz <oz-agent@warp.dev>
//

import SwiftUI
import AppKit

struct ImageDropView: NSViewRepresentable {
    @Binding var droppedImage: NSImage?
    @Binding var showDropIndicator: Bool
    
    func makeNSView(context: Context) -> DropTargetView {
        let view = DropTargetView()
        view.onImageDropped = { image in
            droppedImage = image
        }
        view.onDragEntered = {
            showDropIndicator = true
        }
        view.onDragExited = {
            showDropIndicator = false
        }
        return view
    }
    
    func updateNSView(_ nsView: DropTargetView, context: Context) {
        // No updates needed
    }
}

class DropTargetView: NSView {
    var onImageDropped: ((NSImage) -> Void)?
    var onDragEntered: (() -> Void)?
    var onDragExited: (() -> Void)?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        registerForDraggedTypes([
            .tiff,
            .png,
            .fileURL,
            NSPasteboard.PasteboardType("public.image"),
            NSPasteboard.PasteboardType("public.jpeg")
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        print("📋 Drag entered!")
        onDragEntered?()
        return .copy
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        print("👋 Drag exited")
        onDragExited?()
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        print("🎯 Performing drag operation...")
        let pasteboard = sender.draggingPasteboard
        
        print("📋 Available types:")
        pasteboard.types?.forEach { type in
            print("  - \(type.rawValue)")
        }
        
        // Try to get image directly from pasteboard (Photos app, Safari)
        if let image = NSImage(pasteboard: pasteboard) {
            print("✅ Got image directly from pasteboard!")
            DispatchQueue.main.async {
                self.onImageDropped?(image)
                self.onDragExited?()
            }
            return true
        }
        
        // Try file URL (Finder)
        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL],
           let url = urls.first,
           let image = NSImage(contentsOf: url) {
            print("✅ Loaded image from file URL: \(url)")
            DispatchQueue.main.async {
                self.onImageDropped?(image)
                self.onDragExited?()
            }
            return true
        }
        
        // Try TIFF data (Photos app backup method)
        if let tiffData = pasteboard.data(forType: .tiff),
           let image = NSImage(data: tiffData) {
            print("✅ Loaded image from TIFF data (\(tiffData.count) bytes)")
            DispatchQueue.main.async {
                self.onImageDropped?(image)
                self.onDragExited?()
            }
            return true
        }
        
        // Try PNG data
        if let pngData = pasteboard.data(forType: .png),
           let image = NSImage(data: pngData) {
            print("✅ Loaded image from PNG data (\(pngData.count) bytes)")
            DispatchQueue.main.async {
                self.onImageDropped?(image)
                self.onDragExited?()
            }
            return true
        }
        
        print("❌ Failed to load image from any pasteboard type")
        onDragExited?()
        return false
    }
}
