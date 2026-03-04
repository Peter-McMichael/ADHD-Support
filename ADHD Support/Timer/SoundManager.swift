//
//  SoundManager.swift
//  ADHD Support
//
//  Created by Peter McMichael on 12/16/25.
//

import Foundation
import AVFoundation

final class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?
    private var ambiencePlayer: AVAudioPlayer?
    
    func playEndOfSessionSound() {
        guard let alarm = Bundle.main.url(forResource: "Chime", withExtension: "wav") else {
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: alarm)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error \(error.localizedDescription)")
        }
    }
    
    func startAmbience(name: String, ext: String) {
        ambiencePlayer?.stop()
        ambiencePlayer = nil
        
        
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("ERROR")
            return
        }
        
        do {
            ambiencePlayer = try AVAudioPlayer(contentsOf: url)
            ambiencePlayer?.numberOfLoops = -1
            ambiencePlayer?.volume = 0.4
            ambiencePlayer?.prepareToPlay()
            ambiencePlayer?.play()
        } catch {
            print("ERROR")
        }
    }
    
    func stopAmbience() {
        ambiencePlayer?.stop()
        ambiencePlayer = nil
    }
    
}
