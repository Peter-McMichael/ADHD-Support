//
//  TodoListView.swift
//  ADHD Support
//
//  Created by Peter McMichael on 2/3/26.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject private var store: TodoStorage
    let theme: AppTheme
    
    
    @State private var draftTitle: String = ""
    @State private var chosenPriority: Priority = .medium
    
    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()
            
            List {
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("", text: $draftTitle, prompt: Text("Add a task...").foregroundStyle(theme.focusColor))
                            .onSubmit {addTask()}
                            .submitLabel(.done)
                            .foregroundStyle(theme.focusColor)
                        HStack(spacing: 12) {
                            Menu {
                                ForEach(Priority.allCases) { p in
                                    Button {
                                        chosenPriority = p
                                    } label : {
                                        Text(p.title)
                                    }
                                }
                            } label: {
                                Label(chosenPriority.title, systemImage: "flag.fill")
                            }
                            
                            Button { addTask() } label: {
                                Label("Add", systemImage: "plus.circle.fill")
                            }
//                            .buttonStyle(.borderedProminent)
//                            .disabled(draftTitle.trimmed.isEmpty)
                        }
                    }
                    .padding(.vertical, 6)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                
                ForEach(store.sections) { section in
                    Section(
                        header: Text(section.title)
                            .font(.headline)
                            .foregroundStyle(.white)
                    ) {
                        ForEach(section.tasks) { task in
                            TodoRow(task: task, theme: theme) {
                                store.toggleDone(for: task)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        .onDelete { offsets in
                            store.deleteTasks(at: offsets, in: section.tasks)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.insetGrouped)
            .navigationTitle("To-Do")
            .tint(theme.focusColor)
        }
    }
    private func addTask() {
        let cleanTitle = draftTitle.trimmed
        guard !cleanTitle.isEmpty else { return }
        
        store.addTask(title: cleanTitle, priority: chosenPriority)
        
        draftTitle = ""
        chosenPriority = .medium
    }
   
}
private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


