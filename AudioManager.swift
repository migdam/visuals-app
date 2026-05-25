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
    private var audioEngine: AVAudioEngine?
    private var playerNode: AVAudioPlayerNode?
    private var melodyPlayerNode: AVAudioPlayerNode?
    private var melodyTimer: Timer?
    
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
        melodyTimer?.invalidate()
        melodyTimer = nil
        playerNode?.stop()
        melodyPlayerNode?.stop()
        audioEngine?.stop()
        playerNode = nil
        melodyPlayerNode = nil
        audioEngine = nil
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
        
        // Stop any existing audio
        stopAmbientSound()
        
        // Create and configure player
        do {
            let engine = AVAudioEngine()
            let player = AVAudioPlayerNode()
            
            engine.attach(player)
            engine.connect(player, to: engine.mainMixerNode, format: audioFormat)
            
            // Set volume on main mixer
            engine.mainMixerNode.outputVolume = Float(volume)
            
            try engine.start()
            
            // Schedule buffer to loop
            player.scheduleBuffer(buffer, at: nil, options: .loops)
            player.play()
            
            // Store references to keep them alive
            self.audioEngine = engine
            self.playerNode = player
            
            // Start melody layer
            startMelody(engine: engine, baseFrequency: frequency, volume: volume)
            
            print("Audio started: \(frequency)Hz at volume \(volume)")
        } catch {
            print("Audio playback error: \(error)")
        }
    }
    
    private func startMelody(engine: AVAudioEngine, baseFrequency: Double, volume: Double) {
        // Create melody player node
        let melodyPlayer = AVAudioPlayerNode()
        engine.attach(melodyPlayer)
        
        let audioFormat = AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: 44100.0,
            channels: 2,
            interleaved: false
        )
        
        guard let format = audioFormat else { return }
        
        engine.connect(melodyPlayer, to: engine.mainMixerNode, format: format)
        self.melodyPlayerNode = melodyPlayer
        
        // Pentatonic scale ratios (5-note scale, no dissonance)
        let pentatonicRatios = [1.0, 9.0/8.0, 5.0/4.0, 3.0/2.0, 5.0/3.0]
        var noteIndex = 0
        
        // Play a new note every 2-4 seconds
        melodyTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.melodyPlayerNode else { return }
            
            // Pick next note in sequence with occasional octave jumps
            let ratio = pentatonicRatios[noteIndex % pentatonicRatios.count]
            let octaveShift = (noteIndex / pentatonicRatios.count) % 3
            let octaveMultiplier = pow(2.0, Double(octaveShift - 1)) // -1, 0, or +1 octaves
            
            let noteFreq = baseFrequency * ratio * octaveMultiplier
            noteIndex += 1
            
            // Generate smooth note with ADSR envelope
            if let noteBuffer = self.generateMelodyNote(
                frequency: noteFreq,
                duration: 2.0,
                volume: volume * 0.15,
                format: format
            ) {
                player.scheduleBuffer(noteBuffer, at: nil, options: [])
                if !player.isPlaying {
                    player.play()
                }
            }
        }
        
        // Fire first note immediately
        melodyTimer?.fire()
    }
    
    private func generateMelodyNote(
        frequency: Double,
        duration: Double,
        volume: Double,
        format: AVAudioFormat
    ) -> AVAudioPCMBuffer? {
        let sampleRate = format.sampleRate
        let samples = Int(sampleRate * duration)
        
        guard let buffer = AVAudioPCMBuffer(
            pcmFormat: format,
            frameCapacity: AVAudioFrameCount(samples)
        ) else { return nil }
        
        buffer.frameLength = buffer.frameCapacity
        
        guard let leftChannel = buffer.floatChannelData?[0],
              let rightChannel = buffer.floatChannelData?[1] else { return nil }
        
        for i in 0..<samples {
            let time = Double(i) / sampleRate
            
            // ADSR envelope: Attack, Decay, Sustain, Release
            let attack = 0.1
            let decay = 0.2
            let sustain = 0.5
            let release = 0.2
            
            var envelope = 1.0
            if time < attack {
                envelope = time / attack
            } else if time < attack + decay {
                let decayTime = (time - attack) / decay
                envelope = 1.0 - (1.0 - sustain) * decayTime
            } else if time < duration - release {
                envelope = sustain
            } else {
                let releaseTime = (time - (duration - release)) / release
                envelope = sustain * (1.0 - releaseTime)
            }
            
            // Pure sine wave with slight vibrato
            let vibrato = 1.0 + 0.003 * sin(2.0 * .pi * 5.0 * time)
            let sample = Float(sin(2.0 * .pi * frequency * vibrato * time) * volume * envelope)
            
            leftChannel[i] = sample
            rightChannel[i] = sample
        }
        
        return buffer
    }
}
