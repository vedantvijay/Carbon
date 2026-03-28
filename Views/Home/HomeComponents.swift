//
//  HomeComponents.swift
//  carbon
//
//  Created by Vedant Vijay on 07/02/26.
//

import SwiftUI

struct HeaderSection: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(greetingText).font(.system(size: 16)).foregroundColor(.white.opacity(0.7))
                Text("Vedant Vijay").font(.system(size: 34, weight: .bold)).foregroundColor(.white)
            }
            Spacer()
            ZStack {
                Circle().fill(Color.white.opacity(0.1)).frame(width: 48, height: 48)
                    .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                Image(systemName: "person.fill")
                    .foregroundColor(AppColors.accent).font(.system(size: 20))
            }
            .accessibilityLabel("Profile")
        }
        .padding(.top, 16).padding(.horizontal)
    }
    
    var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good Morning 🌱" }
        else if hour < 17 { return "Good Afternoon ☀️" }
        else { return "Good Evening 🌙" }
    }
}

struct QuickActionsRow: View {
    @Binding var selectedTab: Tab
    @Binding var showAddEmission: Bool
    var onGoalTapped: () -> Void = {}
    var onTipsTapped: () -> Void = {}
    var onShareTapped: () -> Void = {}
    
    private let actions: [(icon: String, label: String, color: Color)] = [
        ("target", "Goal", AppColors.accent),
        ("plus.circle", "Log", AppColors.actionBlue),
        ("square.and.arrow.up", "Share", AppColors.actionOrange),
        ("leaf", "Tips", AppColors.actionLime)
    ]
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<actions.count, id: \.self) { i in
                let action = actions[i]
                Button(action: {
                    switch i {
                    case 0: onGoalTapped()
                    case 1: showAddEmission = true
                    case 2: onShareTapped()
                    case 3: onTipsTapped()
                    default: break
                    }
                }) {
                    VStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(action.color.opacity(0.15)).frame(width: 52, height: 52)
                            Image(systemName: action.icon)
                                .font(.system(size: 22, weight: .medium)).foregroundColor(action.color)
                        }
                        Text(action.label)
                            .font(.system(size: 12, weight: .medium)).foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct StreakCard: View {
    @ObservedObject var emissionStore: EmissionStore
    
    var body: some View {
        GlassmorphicCard(cornerRadius: 24) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "medal.fill").foregroundColor(.yellow).font(.system(size: 16))
                        Text("Current Streak")
                            .font(.system(size: 15, weight: .medium)).foregroundColor(.white.opacity(0.8))
                    }
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text("\(emissionStore.currentStreak)")
                            .font(.system(size: 48, weight: .bold)).foregroundColor(.white)
                            .contentTransition(.numericText())
                        Text("days")
                            .font(.system(size: 18, weight: .medium)).foregroundColor(.white.opacity(0.6))
                    }
                    Text(streakMessage).font(.system(size: 13)).foregroundColor(.white.opacity(0.6))
                }
                Spacer()
                Text(streakEmoji).font(.system(size: 56))
            }
            .padding(20)
        }
    }
    
    private var streakMessage: String {
        let s = emissionStore.currentStreak
        if s == 0 { return "Log today to start your streak!" }
        if s < 3 { return "Keep going! You're building momentum" }
        if s < 7 { return "Great consistency! 🎯" }
        if s < 14 { return "Amazing streak! Don't break it!" }
        return "Incredible! You're a tracking pro! 🏆"
    }
    
    private var streakEmoji: String {
        let s = emissionStore.currentStreak
        if s == 0 { return "💤" }
        if s < 3 { return "🌱" }
        if s < 7 { return "🔥" }
        if s < 14 { return "⚡" }
        return "🏆"
    }
}

struct WeeklyChartCard: View {
    @ObservedObject var emissionStore: EmissionStore
    private let accentGreen = AppColors.accent
    
    private var weeklyData: [(label: String, value: Double)] { emissionStore.weeklyDailyData() }
    private var maxValue: Double { max(weeklyData.map(\.value).max() ?? 1, 0.1) }
    private var weeklyAvg: Double {
        let total = weeklyData.reduce(0) { $0 + $1.value }
        let active = weeklyData.filter { $0.value > 0 }.count
        return active > 0 ? total / Double(active) : 0
    }
    
    var body: some View {
        GlassmorphicCard(cornerRadius: 24) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(AppColors.actionBlue).font(.system(size: 18))
                        Text("This Week").font(.system(size: 17, weight: .semibold)).foregroundColor(.white)
                    }
                    Spacer()
                    Text("Avg \(String(format: "%.1f", weeklyAvg)) kg")
                        .font(.system(size: 13, weight: .medium)).foregroundColor(.white.opacity(0.5))
                }
                
                if weeklyData.allSatisfy({ $0.value == 0 }) {
                    VStack(spacing: 8) {
                        Text("📊")
                            .font(.system(size: 32))
                        Text("No data this week")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                        Text("Log emissions to see your weekly chart")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.35))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                } else {
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(0..<weeklyData.count, id: \.self) { i in
                            let value = weeklyData[i].value
                            let isToday = i == weeklyData.count - 1
                            VStack(spacing: 8) {
                                if value > 0 {
                                    Text(String(format: "%.1f", value))
                                        .font(.system(size: 9, weight: .medium)).foregroundColor(.white.opacity(0.5))
                                }
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(isToday ? accentGreen : (value > 0 ? Color.white.opacity(0.2) : Color.white.opacity(0.06)))
                                    .frame(height: max(4, CGFloat(value / maxValue) * 100))
                                Text(weeklyData[i].label)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(isToday ? .white : .white.opacity(0.5))
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 120)
                }
            }
            .padding(20)
        }
    }
}

struct RecentActivitiesSection: View {
    @ObservedObject var emissionStore: EmissionStore
    @Binding var selectedTab: Tab
    
    private var recentEntries: [EmissionEntry] { Array(emissionStore.entries.prefix(4)) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Recent Activities").font(.system(size: 20, weight: .bold)).foregroundColor(.white)
                Spacer()
                Button(action: { selectedTab = .history }) {
                    Text("See All").font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.accent)
                }
            }
            
            if recentEntries.isEmpty {
                GlassmorphicCard(cornerRadius: 18) {
                    HStack(spacing: 14) {
                        Text("📝").font(.system(size: 28)).frame(width: 44, height: 44)
                        Text("No activities yet — log your first emission!")
                            .font(.system(size: 14)).foregroundColor(.white.opacity(0.6))
                        Spacer()
                    }
                    .padding(.horizontal, 16).padding(.vertical, 14)
                }
            } else {
                ForEach(recentEntries) { entry in
                    GlassmorphicCard(cornerRadius: 18) {
                        HStack(spacing: 14) {
                            Text(entry.subcategoryEmoji).font(.system(size: 28)).frame(width: 44, height: 44)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(entry.subcategoryName)
                                    .font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                                Text(entry.relativeTime)
                                    .font(.system(size: 13)).foregroundColor(.white.opacity(0.5))
                            }
                            Spacer()
                            Text(String(format: "%.1f kg", entry.calculatedKg))
                                .font(.system(size: 18, weight: .bold)).foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.horizontal, 16).padding(.vertical, 14)
                    }
                }
            }
        }
    }
}
