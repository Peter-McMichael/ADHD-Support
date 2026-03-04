//TodoStorage.swift
//this is the todo list "manager"
//it owns the tasks array, saving/loading,
// and the logic for grouping into sections
//views should not be doing sorting or saving,
// they should call functions in here
//keeping logic here makes it way easier to debug and explain


import Foundation
import Combine


@MainActor
final class TodoStorage: ObservableObject {


    //MARK: - properties
    @Published var tasks: [TodoItem] = [] {
        didSet {
            //any time tasks changes (add/toggle/delete), we save automatically
            //this is simple and keeps the app from forgetting stuff
            saveTasks()
        }
    }


    //this is the key name we use in userdefaults
    private let storageKey = "todoItemsJSON"


    //MARK: - init
    init() {
        //load saved tasks when the app starts
        loadTasks()
    }


    //MARK: - actions
    func addTask(title: String, userPriorityOverride: Priority? = nil) {
        //clean up the text so "   " does not become a fake task
        let cleanTitle = title.trimmed
        guard !cleanTitle.isEmpty else { return }


        //ask the ml model what category this task probably belongs to
        let categoryPrediction = TaskClassifier.shared.predictCategory(for: cleanTitle)
        
        let priorityPrediction = PrioritiesClassifier.shared.predictPriority(for: cleanTitle)
        let predicted = Priority(rawValue: priorityPrediction.label) ?? .medium


        //build the new task object we will store
        let newTask = TodoItem(
            title: cleanTitle,
            predictedPriority: predicted,
            priorityConfidence: priorityPrediction.confidence,
            categoryLabel: categoryPrediction.label,
            categoryConfidence: categoryPrediction.confidence,
            userPriorityOverride: userPriorityOverride
        )


        //new tasks go first so it feels instant
        tasks.insert(newTask, at: 0)
        //save happens automatically because tasks changed
    }
    
    func setUserPriorityOverride(_ override: Priority?, for task: TodoItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id}) else { return }
        tasks[index].userPriorityOverride = override
    }

    func toggleDone(for task: TodoItem) {
        //find the task in our main array (by id) and flip done/not done
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isDone.toggle()
        //save happens automatically because tasks changed
    }


    func deleteTasks(at offsets: IndexSet, in sectionTasks: [TodoItem]) {
        //the list gives us offsets for the section array, not the main tasks array
        //so we delete by id to avoid deleting the wrong thing
        let idsToDelete = offsets.map { sectionTasks[$0].id }
        tasks.removeAll { idsToDelete.contains($0.id) }
        //save happens automatically because tasks changed
    }




    //MARK: - sections for ui
    struct TodoSection: Identifiable {
        let id: TodoCategory
        let title: String
        let tasks: [TodoItem]
    }


    var sections: [TodoSection] {
        //group tasks into buckets based on their category
        //dictionary looks like: category -> [tasks in that category]
        let grouped = Dictionary(grouping: tasks) { $0.category }


        //we return sections in a fixed order so the ui does not jump around
        return TodoCategory.displayOrder.compactMap { category in
            //skip empty categories so we only show headings that actually have tasks
            guard let categoryTasks = grouped[category], !categoryTasks.isEmpty else { return nil }


            return TodoSection(
                id: category,
                title: category.displayTitle,
                tasks: sortForDisplay(categoryTasks)
            )
        }
    }


    //MARK: - sorting
    private func sortForDisplay(_ tasks: [TodoItem]) -> [TodoItem] {
        //this decides the order tasks appear inside a category
        tasks.sorted { a, b in
            //not done tasks first
            if a.isDone != b.isDone { return b.isDone }


            //higher priority first
            if a.effectivePriority.sortRank != b.effectivePriority.sortRank {
                return a.effectivePriority.sortRank < b.effectivePriority.sortRank
            }


            //newer first
            return a.createdAt > b.createdAt
        }
    }


    //MARK: - persistence
    private func saveTasks() {
        //turn the tasks array into json data and store it in userdefaults
        //userdefaults is fine here because this is small data, not like photos or videos
        do {
            let data = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            //if saving fails, the app still runs, but tasks might not persist
            print("Todo save error: \(error)")
        }
    }


    private func loadTasks() {
        //grab saved json from userdefaults, and turn it back into [TodoItem]
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            tasks = try JSONDecoder().decode([TodoItem].self, from: data)
        } catch {
            //if decoding fails, we reset to empty so the app does not crash
            print("Todo load error: \(error)")
            tasks = []
        }
    }
    
    func clearCompleted() {
        tasks.removeAll { $0.isDone }
    }
}


//MARK: - helpers
private extension String {
    var trimmed: String {
        //small helper so we do not repeat this line everywhere
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}




