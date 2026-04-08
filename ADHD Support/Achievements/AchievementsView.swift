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
                    achievementRow(for: achievement)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
        .navigationTitle("Achievements")
    }
    
    @ViewBuilder
    private func achievementRow(for achievement: AchievementID) -> some View {
        let unlocked = achievementStore.isUnlocked(achievement)
        let progressText = achievementStore.progressText(for: achievement)
        let progressFraction = achievementStore.progressFraction(for: achievement)
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Image(systemName: unlocked ? "checkmark.seal.fill" : "lock.fill")
                    .foregroundStyle(unlocked ? theme.focusColor : .white.opacity(0.55))
            }
            
            Text(achievement.detail)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
            
            HStack(spacing: 10) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.16))
                        Capsule()
                            .fill(theme.focusColor)
                            .frame(width: geo.size.width * progressFraction)
                    }
                }
                .frame(height: 8)
                
                Text(progressText)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(theme.chromeColor)
                    .monospacedDigit()
            }
        }
        .padding(14)
        .background(.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(theme.focusColor.opacity(unlocked ? 0.35 : 0.15), lineWidth: 1)
        }
        .padding(.vertical, 6)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
}
