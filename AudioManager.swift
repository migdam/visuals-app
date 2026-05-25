//
//  AudioManager.swift
//  Visuals
//
//  Co-Authored-By: Oz <oz-agent@warp.dev>
//

import AVFoundation
import SwiftUI

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    @Published var isEnabled: Bool = true
    @Published var volume: Double = 0.3
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private var ambientPlayer: AVAudioPlayer?
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        #if os(macOS)
        // macOS doesn't need audio session setup
        #else
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
        #endif
    }
    
    func playTransitionSound() {
        guard isEnabled else { return }
        
        // Generate a pleasant transition sound
        let systemSoundID: SystemSoundID = 1057 // Tink sound
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    func playUISound() {
        guard isEnabled else { return }
        
        let systemSoundID: SystemSoundID = 1104 // Click sound
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    func startAmbientSound(for visualization: VisualizationType) {
        guard isEnabled else { return }
        
        stopAmbientSound()
        
        // Generate ambient tones based on visualization
        switch visualization {
        case .particles:
            playGeneratedTone(frequency: 220.0, duration: 10.0, volume: volume * 0.2)
        case .sphere:
            playGeneratedTone(frequency: 174.0, duration: 10.0, volume: volume * 0.15)
        case .glassCards:
            playGeneratedTone(frequency: 432.0, duration: 10.0, volume: volume * 0.2)
        case .waves:
            playGeneratedTone(frequency: 136.0, duration: 10.0, volume: volume * 0.2)
        case .galaxy:
            playGeneratedTone(frequency: 256.0, duration: 10.0, volume: volume * 0.15)
        case .aurora:
            playGeneratedTone(frequency: 396.0, duration: 10.0, volume: volume * 0.2)
        }
    }
    
    func stopAmbientSound() {
        ambientPlayer?.stop()
        ambientPlayer = nil
    }
    
    private func playGeneratedTone(frequency: Double, duration: Double, volume: Double) {
        let sampleRate = 44100.0
        let amplitude = 0.3 * volume
        let samples = Int(sampleRate * duration)
        
        // Create audio buffer
        var audioData = [Float]()
        
        for i in 0..<samples {
            let time = Double(i) / sampleRate
            
            // Create a pleasant tone with harmonics
            let fundamental = sin(2.0 * .pi * frequency * time)
            let harmonic2 = sin(2.0 * .pi * frequency * 2.0 * time) * 0.3
            let harmonic3 = sin(2.0 * .pi * frequency * 3.0 * time) * 0.15
            
            // Add envelope (fade in/out)
            let fadeIn = min(1.0, time * 4.0)
            let fadeOut = min(1.0, (duration - time) * 2.0)
            let envelope = fadeIn * fadeOut
            
            let sample = Float((fundamental + harmonic2 + harmonic3) * amplitude * envelope)
            audioData.append(sample)
        }
        
        // Create audio buffer
        guard let audioFormat = AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: sampleRate,
            channels: 2,
            interleaved: false
        ) else { return }
        
        guard let buffer = AVAudioPCMBuffer(
            pcmFormat: audioFormat,
            frameCapacity: AVAudioFrameCount(samples)
        ) else { return }
        
        buffer.frameLength = buffer.frameCapacity
        
        // Fill both channels with the same data
        if let leftChannel = buffer.floatChannelData?[0],
           let rightChannel = buffer.floatChannelData?[1] {
            for i in 0..<samples {
                leftChannel[i] = audioData[i]
                rightChannel[i] = audioData[i]
            }
        }
        
        // Create and configure player
        do {
            let engine = AVAudioEngine()
            let playerNode = AVAudioPlayerNode()
            
            engine.attach(playerNode)
            engine.connect(playerNode, to: engine.mainMixerNode, format: audioFormat)
            
            try engine.start()
            playerNode.scheduleBuffer(buffer, at: nil, options: .loops)
            playerNode.play()
            
            // Store reference (simplified - in production would need better management)
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                playerNode.stop()
                engine.stop()
            }
        } catch {
            print("Audio playback error: \(error)")
        }
    }
}
