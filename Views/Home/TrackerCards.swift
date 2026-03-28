//
//  TrackerCards.swift
//  carbon
//
//  Created by Vedant Vijay on 09/02/26.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let iconColor: Color
    let iconBg: Color
    
    var body: some View {
        GlassmorphicCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 20) {
                ZStack {
                    Circle()
                        .fill(iconBg)
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.system(size: 18, weight: .medium))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                    Text(value)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    Text(unit)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
    }
}

struct TodaysImpactCard: View {
    @ObservedObject var emissionStore: EmissionStore
    
    private let accentGreen = AppColors.accent
    @AppStorage("dailyGoal") private var dailyGoal: Double = 10.0
    
    private var progressRatio: Double {
        min(emissionStore.todayTotal / dailyGoal, 1.0)
    }
    
    private var progressColor: Color {
        if progressRatio < 0.5 { return Color(red: 0.1, green: 0.9, blue: 0.4) }
        if progressRatio < 0.8 { return .orange }
        return .red
    }
    
    var body: some View {
        GlassmorphicCard(cornerRadius: 24) {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.2, green: 0.8, blue: 0.5).opacity(0.2))
                            .frame(width: 40, height: 40)
                        Image(systemName: "leaf")
                            .foregroundColor(Color(red: 0.2, green: 0.8, blue: 0.5))
                            .font(.system(size: 18, weight: .medium))
                    }
                    
                    Text("Today's Impact")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Spacer()
                    
                    Image(systemName: emissionStore.todayTotal < dailyGoal ? "arrow.down.right" : "arrow.up.right")
                        .foregroundColor(emissionStore.todayTotal < dailyGoal ? accentGreen : .red)
                        .font(.system(size: 18, weight: .bold))
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.1f", emissionStore.todayTotal))
                        .font(.system(size: 64, weight: .bold))
                        .foregroundColor(.white)
                        .contentTransition(.numericText())
                    
                    Text("kg CO₂")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.15))
                            .frame(height: 8)
                        Capsule()
                            .fill(progressColor)
                            .frame(height: 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .scaleEffect(x: max(0.01, progressRatio), y: 1, anchor: .leading)
                    }
                    .frame(height: 8)
                    
                    let pctBelow = max(0, (1 - progressRatio)) * 100
                    Text(pctBelow > 0
                         ? "\(Int(pctBelow))% below your daily goal"
                         : "Daily goal exceeded")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 4)
            }
            .padding(24)
        }
    }
}

