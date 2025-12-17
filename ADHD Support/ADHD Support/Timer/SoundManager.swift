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
}
