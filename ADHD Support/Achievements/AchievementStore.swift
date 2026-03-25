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
    private let progressKey = "achievementProgressJSON"
    private let countersKey = "achievementCountersJSON"
    
    
    private var tasksCompletedCount: Int = 0
    private var tasksAddedCount: Int = 0
    
    private struct CounterSnapshot: Codable {
        let tasksCompletedCount: Int
        let tasksAddedCount: Int
    }
    init() {
        loadProgress()
        
        loadCounters()
        
        entriesExist()
        
        
    }
    
    func isUnlocked(_ id: AchievementID) -> Bool {
        progressByID[id]?.isUnlocked ?? false
    }
    
    func unlockedAt(_ id: AchievementID) -> Date? {
        progressByID[id]?.unlockedAt
    }
    
    func recordTaskAdded() {
        tasksAddedCount += 1
        saveCounters()
        
        if tasksAddedCount >= 1 {
            unlock(.firstTaskAdded)
        }
    }
    
    func recordTaskCompleted(task: TodoItem) {
        tasksCompletedCount += 1
        saveCounters()
        
        if tasksCompletedCount >= 1 {
            unlock(.firstTaskCompleted)
        }
        
        if tasksCompletedCount >= 10 {
            unlock(.tenTasksCompleted)
        }
        
        if task.effectivePriority == .URGENT {
            unlock(.firstUrgentTaskCompleted)
        }
        
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
        for id in AchievementID.allCases {
            if progressByID[id] == nil {
                progressByID[id] = AchievementProgress()
            }
        }
    }
    
    private func saveProgress() {
        do {
            let data = try JSONEncoder().encode(progressByID)
            UserDefaults.standard.set(data, forKey: progressKey)
        } catch {
            print("Achievement save error: \(error)")
        }
    }
    
    private func saveCounters() {
        let snapshot = CounterSnapshot(
            tasksCompletedCount: tasksCompletedCount,
            tasksAddedCount: tasksAddedCount
        )
        
        do {
            let data = try JSONEncoder().encode(snapshot)
            UserDefaults.standard.set(data, forKey: countersKey)
        } catch {
            print("Achievement counter save error: \(error)")
        }
    }
    
    private func loadProgress() {
        guard let data = UserDefaults.standard.data(forKey: progressKey)
        else { return }
        
        do {
            progressByID = try JSONDecoder().decode([AchievementID: AchievementProgress].self, from: data)
        } catch {
            print("Achievement load error: \(error)")
            progressByID = [:]
        }
    }
    
    private func loadCounters() {
        guard let data = UserDefaults.standard.data(forKey: countersKey)
        else { return }
        
        do {
            let snapshot = try JSONDecoder().decode(CounterSnapshot.self, from: data)
            tasksCompletedCount = snapshot.tasksCompletedCount
            tasksAddedCount = snapshot.tasksAddedCount
            
        } catch {
            print("Achievement counter load error: \(error)")
            tasksCompletedCount = 0
            tasksAddedCount = 0
        }
    }
    
    
    
    
    
    
    
    
}









