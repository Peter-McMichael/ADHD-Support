//
//  AchievementStore.swift
//  ADHD Support
//
//  Created by Peter McMichael on 3/10/26.
//

import Foundation
import Combine

@MainActor
// means main character, royalty

final class AchievementStore: ObservableObject {
    
    @Published private(set) var progressByID: [AchievementID: AchievementProgress] = [:] {
        didSet {
            saveProgress()
        }
        
    }
    
    @Published var newlyUnlockedAchievement: AchievementID? = nil
    private let storageKey = "achievementProgressJSON"
    
    
    init() {
        loadProgress()
        
        entriesExist()
    }
    
    func isUnlocked(_ id: AchievementID) -> Bool {
        progressByID[id]?.isUnlocked ?? false
    }
    
    func unlockedAt(_ id: AchievementID) -> Date? {
        progressByID[id]?.unlockedAt
    }
    func recordTaskCompleted() {
        unlock(.firstTaskCompleted)
    }
    func clearNewlyUnlockedAchievements() {
        newlyUnlockedAchievement = nil
    }
    
    private func unlock(_ id: AchievementID) {
        var entry = progressByID[id] ?? AchievementProgress()
        
        guard !entry.isUnlocked else { return }
        
        entry.isUnlocked = true
        entry.unlockedAt = Date()
        
        progressByID[id] = entry
        
        newlyUnlockedAchievement = id
    }
    
    private func entriesExist() {
        if progressByID[.firstTaskCompleted] == nil {
            progressByID[.firstTaskCompleted] = AchievementProgress()
        }
    }
    
    private func saveProgress() {
        do {
            let data = try JSONEncoder().encode(progressByID)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Achievement save error: \(error)")
        }
    }
    
    private func loadProgress() {
        guard let data = UserDefaults.standard.data(forKey: storageKey)
        else { return }
        
        do {
            progressByID = try JSONDecoder().decode([AchievementID: AchievementProgress].self, from: data)
        } catch {
            print("Achievement load error: \(error)")
            progressByID = [:]
        }
    }
    
    
    
    
    
    
    
    
}









