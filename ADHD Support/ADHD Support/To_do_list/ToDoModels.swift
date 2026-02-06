//
//  ToDoModels.swift
//  ADHD Support
//
//  Created by Peter McMichael on 1/20/26.
//

import Foundation

enum Priority: String, Codable, CaseIterable, Identifiable {
    case low
    case medium
    case high
    case URGENT
    
    var id: String {rawValue}
    var title: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .URGENT: return "URGENT"
        }
    }
    var sortRank: Int {
        switch self {
        case .URGENT: return 0
        case .high: return 1
        case .medium: return 2
        case .low: return 3
        
        }
    }
}


enum TodoCategory: String, Codable, CaseIterable, Identifiable {
    case homework = "Homework"
    case testPrep = "TestPrep"
    case longProject = "LongProject"
    case extracurricular = "Extracurricular"
    case chores = "Chores"
    case other = "Other"
    
    var id: String { rawValue }
    
    static let displayOrder: [TodoCategory] = [
        .testPrep,
        .extracurricular,
        .longProject,
        .homework,
        .chores,
        .other
    ]
    
    var displayTitle: String {
        switch self {
        case .homework: return "Homework"
        case .testPrep: return "Test Prep"
        case .longProject: return "Long Project"
        case .extracurricular: return "Extracurricular"
        case .chores: return "Chores"
        case .other: return "Other"
        }
    }
    
    init(rawLabel: String) {
        let trimmed = rawLabel.trimmed
        guard !trimmed.isEmpty, trimmed != "Unknown" else {
            self = .other
            return
        }
        
        let normalized = trimmed
            .lowercased()
            .replacingOccurrences(of: "", with: "")
            .replacingOccurrences(of: "_", with: "")
        
        switch normalized {
        case "homework", "hw":
            self = .homework
        case "testprep", "testpreparation":
            self = .testPrep
        case "longproject", "longtermproject", "project":
            self = .longProject
        case "extracurricular", "extracurr":
            self = .extracurricular
        case "chores", "chore":
            self = .chores
        default:
            self = .other
        }
        
    }
}


struct TodoItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var isDone: Bool
    var priority: Priority
    var createdAt: Date
    
    
    var categoryLabel: String
    var categoryConfidence: Double
    
    
    init(title: String, priority: Priority, categoryLabel: String, categoryConfidence: Double) {
        self.id = UUID()
        self.title = title
        self.isDone = false
        self.priority = priority
        self.createdAt = Date()
        self.categoryLabel = categoryLabel
        self.categoryConfidence = categoryConfidence
    }
    
    
    var category: TodoCategory {
        TodoCategory(rawLabel: categoryLabel)
    }
}




private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
