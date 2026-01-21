//
//  TodoStorage.swift
//  ADHD Support
//
//  Created by Peter McMichael on 1/20/26.
//

import Foundation
import Combine

@MainActor
final class TodoStorage: ObservableObject {
    @Published var tasks: [TodoItem] = [] {
        didSet {
            saveTasks()
        }
    }
    
    private let storageKey = "todoItemsJSON"
    
    init() {
        loadTasks()
    }
    
    func addTask(title: String, priority: Priority) {
        let cleanTitle = title.trimmed
        guard !cleanTitle.isEmpty else { return }
        
        let prediction = TaskClassifier.shared.predictCategory(for: cleanTitle)
        
        let newTask = TodoItem(
            title: cleanTitle,
            priority: priority,
            categoryLabel: prediction.label,
            categoryConfidence: prediction.confidence
        )
        
        tasks.insert(newTask, at: 0)
    }
    
    func toggleDone(for task: TodoItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isDone.toggle()
    }
    
    func deleteTasks(at offsets: IndexSet, in sectionTasks: [TodoItem]) {
        let idsToDelete = offsets.map { sectionTasks[$0].id }
        tasks.removeAll { idsToDelete.contains($0.id)}
    }
    
    struct TodoSection: Identifiable {
        let id: TodoCategory
        let title: String
        let tasks: [TodoItem]
    }
    
    var sections: [TodoSection] {
        let grouped = Dictionary(grouping: tasks) {$0.category}
        return TodoCategory.displayOrder.compactMap { category in
            guard let categoryTasks = grouped[category], !categoryTasks.isEmpty else { return nil}
            return TodoSection(id: category, title: category.displayTitle, tasks: sortForDisplay(categoryTasks))
        }
    }
    
    private func sortForDisplay(_ tasks: [TodoItem]) -> [TodoItem] {
        tasks.sorted { a, b in
            if a.isDone != b.isDone { return b.isDone }
            
            if a.priority.sortRank != b.priority.sortRank {
                return a.priority.sortRank < b.priority.sortRank
            }
            return a.createdAt > b.createdAt
        }
    }
    
    private func saveTasks() {
        do {
            let data = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Error")
        }
    }

    private func loadTasks() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            tasks = try JSONDecoder().decode([TodoItem].self, from: data)
        } catch {
            print("Todo load error: \(error)")
            tasks = []
        }
    }

}



private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

