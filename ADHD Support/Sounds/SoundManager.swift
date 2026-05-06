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
    
    
    //tracks which ambience is loaded and makes it run smoohthly.
    //Does not restart loop
    
    private var currentAmbienceKey: String?
    
    
    
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
        let newKey = "\(name).\(ext)"
        
        //if the same ambience is already playing, do nothing (return empty)
        if currentAmbienceKey == newKey, let ambiencePlayer, ambiencePlayer.isPlaying {
            return
        }
        // if the same ambience is loaded by paused, just resume it
        if currentAmbienceKey == newKey, let ambiencePlayer {
            ambiencePlayer.play()
            return
        }
        
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
