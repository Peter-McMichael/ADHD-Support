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
                ForEach(AchievementID.allCases) { achievement in
                    achievementRow(title: achievement.title, detail: achievement.detail, unlocked: achievementStore.isUnlocked(achievement))
                }
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
