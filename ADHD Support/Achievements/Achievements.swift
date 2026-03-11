//
//  achievements.swift
//  ADHD Support
//
//  Created by Peter McMichael on 3/10/26.
//

import Foundation

enum AchievementID: String, Codable, Identifiable {
    case firstTaskCompleted
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .firstTaskCompleted:
            return "First Win!"
        }
    }
    
    var detail: String {
        switch self {
        case .firstTaskCompleted:
            return "Complete 1 task"
        }
    }
}


struct AchievementProgress: Codable {
    var isUnlocked: Bool = false
    var unlockedAt: Date? = nil
}
