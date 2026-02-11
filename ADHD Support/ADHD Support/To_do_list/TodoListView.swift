//
//  TodoListView.swift
//  ADHD Support
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject private var store: TodoStorage
    let theme: AppTheme
    
    
    @State private var draftTitle: String = ""

    //nil means "Auto" (use ML predicted priority)
    @State private var chosenPriorityOverride: Priority? = nil

    
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
                                //Auto mode
                                Button {
                                    chosenPriorityOverride = nil
                                } label: {
                                    Text("Auto")
                                }

                                Divider()

                                //Manual override mode
                                ForEach(Priority.allCases) { p in
                                    Button {
                                        chosenPriorityOverride = p
                                    } label: {
                                        Text(p.title)
                                    }
                                }
                            } label: {
                                Label(chosenPriorityOverride?.title ?? "Auto", systemImage: "flag.fill")
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
                            TodoRow(
                                task: task,
                                theme: theme,
                                onToggle: { store.toggleDone(for: task) },
                                onSetPriorityOverride: { newOverride in
                                    store.setUserPriorityOverride(newOverride, for: task)
                                }
                            )
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
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        store.clearCompleted()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
    
    private func addTask() {
        let cleanTitle = draftTitle.trimmed
        guard !cleanTitle.isEmpty else { return }

        //WHY: we do not decide final priority here
        //HOW: we pass the optional user override into storage
        //storage will always save the ML prediction too
        store.addTask(title: cleanTitle, userPriorityOverride: chosenPriorityOverride)

        draftTitle = ""
        chosenPriorityOverride = nil
    }

   
}
private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


