//
//  EcoTipsView.swift
//  carbon
//
//  Created by Vedant Vijay on 18/02/26.
//

import SwiftUI

struct EcoTipsView: View {
    @ObservedObject var emissionStore: EmissionStore
    @StateObject private var tipStore = TipStore()
    
    private let accent = AppColors.accent
    
    private var breakdown: [(category: EmissionCategory, total: Double)] {
        emissionStore.categoryBreakdown(since: 30).sorted { $0.total > $1.total }
    }
    private var topCategory: EmissionCategory? { breakdown.first?.category }
    private var dailyAvg: Double {
        let days = max(1, emissionStore.totalActiveDays)
        return emissionStore.monthlyTotal / Double(min(days, 30))
    }
    
    var body: some View {
        ZStack {
            BackgroundView().ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Eco Tips").font(.system(size: 34, weight: .bold)).foregroundColor(.white)
                        Text("Personalized for your habits")
                            .font(.system(size: 16)).foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 16).padding(.horizontal)
                    
                    analysisCard
                    if !breakdown.isEmpty { breakdownCard }
                    tipsSection
                    sourceNote
                    Spacer().frame(height: 40)
                }
            }
        }
        .preferredColorScheme(.dark)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    // MARK: - Analysis
    
    private var analysisCard: some View {
        GlassmorphicCard(cornerRadius: 24) {
            VStack(spacing: 20) {
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "chart.line.uptrend.xyaxis").foregroundColor(accent).font(.system(size: 16))
                        Text("Your CO₂ Analysis").font(.system(size: 17, weight: .bold)).foregroundColor(.white)
                    }
                    Spacer()
                    Text("30 days").font(.system(size: 12, weight: .medium)).foregroundColor(.white.opacity(0.4))
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Capsule().fill(.white.opacity(0.08)))
                }
                
                if emissionStore.monthlyTotal > 0 {
                    HStack(spacing: 0) {
                        VStack(spacing: 6) {
                            Text(String(format: "%.1f", dailyAvg))
                                .font(.system(size: 32, weight: .bold)).foregroundColor(.white)
                            Text("kg CO₂/day").font(.system(size: 12)).foregroundColor(.white.opacity(0.5))
                            let pct = ((dailyAvg - 16.0) / 16.0) * 100
                            HStack(spacing: 4) {
                                Image(systemName: pct < 0 ? "arrow.down.right" : "arrow.up.right").font(.system(size: 10))
                                Text(String(format: "%.0f%% vs global avg", abs(pct))).font(.system(size: 11, weight: .medium))
                            }
                            .foregroundColor(pct < 0 ? accent : .orange)
                        }.frame(maxWidth: .infinity)
                        
                        Rectangle().fill(.white.opacity(0.1)).frame(width: 1, height: 60)
                        
                        VStack(spacing: 6) {
                            Text(String(format: "%.0f", emissionStore.monthlyTotal))
                                .font(.system(size: 32, weight: .bold)).foregroundColor(.white)
                            Text("kg this month").font(.system(size: 12)).foregroundColor(.white.opacity(0.5))
                            if let top = topCategory {
                                HStack(spacing: 4) {
                                    Text(top.emoji).font(.system(size: 11))
                                    Text("\(top.rawValue) is #1").font(.system(size: 11, weight: .medium))
                                }.foregroundColor(.orange)
                            }
                        }.frame(maxWidth: .infinity)
                    }
                } else {
                    VStack(spacing: 8) {
                        Text("📊").font(.system(size: 36))
                        Text("Start logging emissions to get personalized tips")
                            .font(.system(size: 14)).foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }.frame(maxWidth: .infinity).padding(.vertical, 8)
                }
            }
            .padding(20)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Breakdown
    
    private var breakdownCard: some View {
        GlassmorphicCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 14) {
                Text("Where your CO₂ goes")
                    .font(.system(size: 15, weight: .semibold)).foregroundColor(.white.opacity(0.8))
                let peak = breakdown.first?.total ?? 1
                ForEach(breakdown, id: \.category) { item in
                    HStack(spacing: 10) {
                        Text(item.category.emoji).font(.system(size: 18)).frame(width: 24)
                        Text(item.category.rawValue)
                            .font(.system(size: 14, weight: .medium)).foregroundColor(.white.opacity(0.8))
                            .frame(width: 70, alignment: .leading)
                        ZStack(alignment: .leading) {
                            Capsule().fill(.white.opacity(0.06)).frame(height: 8)
                            Capsule().fill(tint(for: item.category)).frame(height: 8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .scaleEffect(x: max(0.02, item.total / peak), y: 1, anchor: .leading)
                        }
                        Text(String(format: "%.0f kg", item.total))
                            .font(.system(size: 13, weight: .bold)).foregroundColor(.white)
                            .frame(width: 50, alignment: .trailing)
                    }
                }
            }
            .padding(18)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Tips
    
    private var tipsSection: some View {
        let relevant = tipStore.personalizedTips(for: emissionStore)
        let label = topCategory?.rawValue ?? "High-Impact"
        let savings = relevant.reduce(0) { $0 + $1.annualSavingsKg }
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                if let top = topCategory { Text(top.emoji).font(.system(size: 18)) }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Tips for \(label)").font(.system(size: 20, weight: .bold)).foregroundColor(.white)
                    if topCategory != nil {
                        Text("Your biggest emission area")
                            .font(.system(size: 12)).foregroundColor(.white.opacity(0.5))
                    }
                }
            }.padding(.horizontal)
            
            if savings > 0 {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles").foregroundColor(.yellow).font(.system(size: 14))
                    Text("Potential annual savings: **\(String(format: "%.0f", savings)) kg CO₂**")
                        .font(.system(size: 14)).foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal, 16).padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12).fill(Color.yellow.opacity(0.08))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.yellow.opacity(0.15), lineWidth: 1))
                )
                .padding(.horizontal)
            }
            
            ForEach(relevant) { tip in TipCard(tip: tip).padding(.horizontal) }
        }
    }
    
    private var sourceNote: some View {
        GlassmorphicCard(cornerRadius: 16) {
            HStack(spacing: 12) {
                Image(systemName: "book.closed.fill").foregroundColor(.white.opacity(0.4)).font(.system(size: 14))
                Text("Tips sourced from IEA, UNEP, Nature, and peer-reviewed climate research.")
                    .font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
            }
            .padding(14)
        }
        .padding(.horizontal)
    }
    
    private func tint(for category: EmissionCategory) -> Color {
        AppColors.color(for: category)
    }
}
