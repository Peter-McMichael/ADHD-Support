//
//  TaskPomodoroView.swift
//  ADHD Support
//
//  Created by Peter McMichael on 2/10/26.
//

import SwiftUI

struct TaskPomodoroView: View {
    let task: TodoItem
    let theme: AppTheme
    
    
    private var recommended: (focus: Int, rest: Int, label: String) {
        switch task.effectivePriority {
        case .URGENT:
            return (45, 10, "Recommended (Urgent)")
        case .high:
            return (35, 7, "Recommended (High)")
        case .medium:
            return (25, 5, "Recommended (Medium)")
        case .low:
            return (15, 3, "Recommended (Low)")
        }
    }
    
    var body: some View{
        ZStack {
            theme.background.ignoresSafeArea()
            
            VStack(spacing: 12) {
                Text(task.title)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(.top, 8)
                
                
                countdownTimer(
                    theme: theme,
                    initialFocusMinutes: recommended.focus,
                    initialBreakMinutes: recommended.rest,
                    
                
                    recommendedFocusMinutes: recommended.focus,
                    recommendedBreakMinutes: recommended.rest,
                    recommendedLabel: recommended.label
                )
                    
            }
            .padding()
        }
        .navigationTitle("Pomodoro")
        .navigationBarTitleDisplayMode(.inline)
    }
}
