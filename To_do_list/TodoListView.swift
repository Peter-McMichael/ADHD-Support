
//
//  TodoListView.swift
//  ADHD Support
//


import SwiftUI


struct TodoListView: View {
   @EnvironmentObject private var store: TodoStorage
   let theme: AppTheme
   @State private var draftTitle: String = ""
   @State private var chosenPriorityOverride: Priority? = nil


   var body: some View {
       ZStack {
           theme.background.ignoresSafeArea()


           List {
               addTaskSection


               ForEach(store.sections) { section in
                   Section {
                       ForEach(section.tasks) { task in
                           TodoRow(
                               task: task,
                               theme: theme,
                               onToggle: { store.toggleDone(for: task) },
                               onSetPriorityOverride: { newOverride in
                                   store.setUserPriorityOverride(newOverride, for: task)
                               }
                           )
                           .clearRowStyle()
                       }
                       .onDelete { offsets in
                           store.deleteTasks(at: offsets, in: section.tasks)
                       }
                   } header: {
                       Text(section.title)
                           .font(.headline)
                           .foregroundStyle(.white)
                   }
                   .clearSectionStyle()
               }
           }
           .scrollContentBackground(.hidden)
           .listStyle(.plain)
           .tint(theme.focusColor)
           .toolbar {
               ToolbarItem(placement: .topBarTrailing) {
                   Button { store.clearCompleted() } label: {
                       Image(systemName: "trash")
                   }
               }
           }
       }
   }


   // MARK: - Sections


   private var addTaskSection: some View {
       Section {
           VStack(alignment: .leading, spacing: 10) {
               TextField(
                   "",
                   text: $draftTitle,
                   prompt: Text("Add a task...").foregroundStyle(theme.focusColor)
               )
               .onSubmit { addTask() }
               .submitLabel(.done)
               .foregroundStyle(theme.focusColor)


               HStack(spacing: 12) {
                   Menu {
                       Button { chosenPriorityOverride = nil } label: { Text("Auto") }
                       Divider()


                       ForEach(Priority.allCases) { p in
                           Button { chosenPriorityOverride = p } label: { Text(p.title) }
                       }
                   } label: {
                       Label(chosenPriorityOverride?.title ?? "Auto", systemImage: "flag.fill")
                   }


                   Button { addTask() } label: {
                       Label("Add", systemImage: "plus.circle.fill")
                   }
               }
           }
           .padding(.vertical, 6)
       }
       .clearSectionStyle()
   }


   // MARK: - Actions


   private func addTask() {
       let cleanTitle = draftTitle.trimmed
       guard !cleanTitle.isEmpty else { return }


       // WHY: we do not decide final priority here
       // HOW: we pass the optional user override into storage
       // storage will always save the ML prediction too
       store.addTask(title: cleanTitle, userPriorityOverride: chosenPriorityOverride)


       draftTitle = ""
       chosenPriorityOverride = nil
   }
}


// MARK: - Small helpers to avoid modifier spam


private extension View {


   func clearRowStyle() -> some View {
       self
           .listRowBackground(Color.clear)
           .listRowSeparator(.hidden)
   }


   func clearSectionStyle() -> some View {
       self
           .listRowBackground(Color.clear)
           .listRowSeparator(.hidden)
   }
}


private extension String {
   var trimmed: String {
       trimmingCharacters(in: .whitespacesAndNewlines)
   }
}






