//
//  ToDoRow.swift
//  ADHD Support
//
//  Created by Peter McMichael on 2/3/26.
//

import SwiftUI

struct TodoRow: View {
    let task: TodoItem
    let theme: AppTheme
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(task.isDone ? .secondary : theme.focusColor)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .strikethrough(task.isDone)
                    .foregroundStyle(task.isDone ? .white.opacity(0.6) : .white)
                
                Text("Priority: \(task.priority.title)")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.75))
            }
            
        }
    }
}
