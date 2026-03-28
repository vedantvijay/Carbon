//
//  ImpactDetailView.swift
//  carbon
//
//  Created by Vedant Vijay on 13/02/26.
//

import SwiftUI

// MARK: - Impact Detail View

struct ImpactDetailView: View {
    @ObservedObject var emissionStore: EmissionStore
    @Environment(\.dismiss) private var dismiss
    
    private let accentGreen = AppColors.accent
    @AppStorage("dailyGoal") private var dailyGoal: Double = 10.0
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    // Hero card
                    heroCard
                    
                    // Category breakdown
                    categoryBreakdownCard
                    
                    // Hourly trend
                    hourlyTrendCard
                    
                    // Insights
                    insightsCard
                    
                    Spacer().frame(height: 40)
                }
                .padding(.top, 16)
            }
        }
        .preferredColorScheme(.dark)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    // MARK: - Hero Card
    
    private var heroCard: some View {
        GlassmorphicCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(accentGreen.opacity(0.2))
                            .frame(width: 48, height: 48)
                        Image(systemName: "leaf.fill")
                            .foregroundColor(accentGreen)
                            .font(.system(size: 22))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Today's Impact")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        Text(formattedDate)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    
                    Spacer()
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", emissionStore.todayTotal))
                        .font(.system(size: 56, weight: .bold))
                        .foregroundColor(.white)
                        .contentTransition(.numericText())
                    Text("kg CO₂")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                // Progress bar — use fixed proportional width instead of GeometryReader
                VStack(alignment: .leading, spacing: 8) {
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.white.opacity(0.1)).frame(height: 10)
                        Capsule().fill(progressColor)
                            .frame(width: nil, height: 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .scaleEffect(x: progressRatio, y: 1, anchor: .leading)
                    }
                    .frame(height: 10)
                    
                    Text(progressText)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(20)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Category Breakdown
    
    private var categoryBreakdownCard: some View {
        let breakdown = emissionStore.categoryBreakdown(since: 1)
        
        return GlassmorphicCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "chart.pie.fill")
                        .foregroundColor(accentGreen)
                    Text("Breakdown by Category")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                if breakdown.isEmpty {
                    Text("No emissions logged today")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                } else {
                    ForEach(breakdown, id: \.category) { item in
                        let ratio = emissionStore.todayTotal > 0 ? item.total / emissionStore.todayTotal : 0
                        
                        HStack(spacing: 12) {
                            Text(item.category.emoji)
                                .font(.system(size: 22))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.category.rawValue)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.white)
                                
                                // Fixed-proportion bar instead of GeometryReader
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.white.opacity(0.08))
                                        .frame(height: 6)
                                    Capsule()
                                        .fill(AppColors.color(for: item.category))
                                        .frame(height: 6)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .scaleEffect(x: max(0.03, ratio), y: 1, anchor: .leading)
                                }
                                .frame(height: 6)
                            }
                            
                            Spacer()
                            
                            Text(String(format: "%.1f kg", item.total))
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(20)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Hourly Trend
    
    private var hourlyTrendCard: some View {
        let hourly = emissionStore.todayHourlyData()
        let hourlyMax = max(hourly.map(\.value).max() ?? 1, 0.1)
        
        return GlassmorphicCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .foregroundColor(accentGreen)
                    Text("Hourly Trend")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                if hourly.allSatisfy({ $0.value == 0 }) {
                    VStack(spacing: 8) {
                        Text("⏱️")
                            .font(.system(size: 32))
                        Text("No emissions logged today")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                        Text("Your hourly breakdown will appear here")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.35))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 110)
                } else {
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(0..<hourly.count, id: \.self) { i in
                            VStack(spacing: 4) {
                                if hourly[i].value > 0 {
                                    Text(String(format: "%.1f", hourly[i].value))
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(hourly[i].value > 0 ? accentGreen : Color.white.opacity(0.08))
                                    .frame(height: max(4, CGFloat(hourly[i].value / hourlyMax) * 80))
                                
                                Text(hourly[i].label)
                                    .font(.system(size: 10))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 110)
                }
            }
            .padding(20)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Insights
    
    private var insightsCard: some View {
        GlassmorphicCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text("Today's Insights")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                InsightRow(emoji: "🎯", text: "Daily goal: Keep emissions under 10 kg CO₂")
                InsightRow(emoji: "📊", text: "Your average: \(String(format: "%.1f", emissionStore.weeklyTotal / 7)) kg per day this week")
                InsightRow(emoji: "💡", text: "Tip: Try public transport to reduce travel emissions")
            }
            .padding(20)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helpers
    
    private var formattedDate: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMM d"
        return f.string(from: Date())
    }
    
    private var progressRatio: Double {
        min(emissionStore.todayTotal / dailyGoal, 1.0)
    }
    
    private var progressColor: Color {
        if progressRatio < 0.5 { return accentGreen }
        if progressRatio < 0.8 { return .orange }
        return .red
    }
    
    private var progressText: String {
        let remaining = max(0, dailyGoal - emissionStore.todayTotal)
        if remaining > 0 {
            return "\(String(format: "%.1f", remaining)) kg remaining of \(String(format: "%.0f", dailyGoal)) kg daily goal"
        }
        return "Daily goal exceeded by \(String(format: "%.1f", emissionStore.todayTotal - dailyGoal)) kg"
    }
}

// MARK: - Insight Row

struct InsightRow: View {
    let emoji: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(emoji)
                .font(.system(size: 16))
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.75))
        }
    }
}

#Preview {
    NavigationStack {
        ImpactDetailView(emissionStore: EmissionStore())
    }
}
