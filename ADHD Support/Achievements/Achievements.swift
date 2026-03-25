//
//  achievements.swift
//  ADHD Support
//
//  Created by Peter McMichael on 3/10/26.
//

import Foundation

enum AchievementID: String, Codable, Identifiable, CaseIterable {
    case firstTaskCompleted
    case tenTasksCompleted
    case firstUrgentTaskCompleted
    case firstTaskAdded
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .firstTaskCompleted:
            return "First Win!"
        case .tenTasksCompleted:
            return "Momentum"
        case .firstUrgentTaskCompleted:
            return "Under Pressure"
        case .firstTaskAdded:
            return "Getting Started"
        }
    }
    
    var detail: String {
        switch self {
        case .firstTaskCompleted:
            return "Complete 1 task"
        case .tenTasksCompleted:
            return "Complete 10 tasks"
        case .firstUrgentTaskCompleted:
            return "Complete 1 urgent task"
        case .firstTaskAdded:
            return "Add 1 task"
        }
    }
}


struct AchievementProgress: Codable {
    var isUnlocked: Bool = false
    var unlockedAt: Date? = nil
}
