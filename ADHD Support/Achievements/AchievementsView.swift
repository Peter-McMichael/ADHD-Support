//
//  AchievementsView.swift
//  ADHD Support
//
//  Created by Peter McMichael on 3/10/26.
//

import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject private var achievementStore: AchievementStore
    let theme: AppTheme
    
    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()
            List {
                achievementRow(title: AchievementID.firstTaskCompleted.title, detail: AchievementID.firstTaskCompleted.detail, unlocked: achievementStore.isUnlocked(.firstTaskCompleted))
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
        .navigationTitle("Achievements")
    }
    
    @ViewBuilder
    private func achievementRow(title: String, detail: String, unlocked: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Image(systemName: unlocked ? "checkmark.seal.fill" : "lock.fill")
                    .foregroundStyle(unlocked ? theme.focusColor : .white.opacity(0.55))
            }
            
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding(.vertical, 0)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}
