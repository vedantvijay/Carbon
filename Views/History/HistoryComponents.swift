//
//  HistoryComponents.swift
//  carbon
//
//  Created by Vedant Vijay on 10/02/26.
//

import SwiftUI

struct HistoryEntryRow: View {
    let entry: EmissionEntry
    
    var body: some View {
        GlassmorphicCard(cornerRadius: 18) {
            HStack(spacing: 14) {
                Text(entry.subcategoryEmoji)
                    .font(.system(size: 28))
                    .frame(width: 44, height: 44)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(entry.subcategoryName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    HStack(spacing: 6) {
                        Text(entry.relativeTime)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.45))
                        if !entry.notes.isEmpty {
                            Circle().fill(Color.white.opacity(0.3)).frame(width: 3, height: 3)
                            Text(entry.notes)
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.45))
                                .lineLimit(1)
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "%.1f", entry.calculatedKg))
                        .font(.system(size: 18, weight: .bold)).foregroundColor(.white)
                    Text("kg CO₂")
                        .font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
                }
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
        }
        .padding(.horizontal)
    }
}

struct PeriodTotalCard: View {
    let period: TimePeriod
    let total: Double
    private let accentGreen = AppColors.accent
    
    var body: some View {
        GlassmorphicCard(cornerRadius: 24) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(period.rawValue)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(String(format: "%.1f", total))
                            .font(.system(size: 42, weight: .bold)).foregroundColor(.white)
                            .contentTransition(.numericText())
                        Text("kg CO₂")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                Spacer()
                ZStack {
                    Circle().fill(accentGreen.opacity(0.15)).frame(width: 52, height: 52)
                    Image(systemName: "leaf.fill").foregroundColor(accentGreen).font(.system(size: 24))
                }
            }
            .padding(20)
        }
        .animation(.smooth(duration: 0.3), value: total)
    }
}

struct EmptyHistoryView: View {
    @Binding var showAddEmission: Bool
    
    var body: some View {
        GlassmorphicCard(cornerRadius: 24) {
            VStack(spacing: 16) {
                Text("📊").font(.system(size: 48))
                Text("No Entries Yet")
                    .font(.system(size: 20, weight: .bold)).foregroundColor(.white)
                Text("Start logging your carbon emissions\nto see your history here")
                    .font(.system(size: 14)).foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                Button(action: { showAddEmission = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                        Text("Add First Entry").font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 14).padding(.horizontal, 28)
                    .background(Capsule().fill(AppColors.accent))
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity).padding(32)
        }
    }
}

