//
//  BarChartCard.swift
//  carbon
//
//  Created by Vedant Vijay on 11/02/26.
//

import SwiftUI

struct BarChartCard: View {
    let data: [(label: String, value: Double)]
    let period: TimePeriod
    
    private let accentGreen = AppColors.accent
    private var maxValue: Double { data.map(\.value).max() ?? 1 }
    
    var body: some View {
        GlassmorphicCard(cornerRadius: 24) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(accentGreen).font(.system(size: 16))
                    Text("Emissions Overview")
                        .font(.system(size: 17, weight: .semibold)).foregroundColor(.white)
                    Spacer()
                    Text(chartSubtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))
                }
                
                if data.allSatisfy({ $0.value == 0 }) {
                    VStack(spacing: 8) {
                        Text("📊")
                            .font(.system(size: 32))
                        Text("No data for this period")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.5))
                        Text("Start logging to see your chart")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.35))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                } else {
                    HStack(alignment: .bottom, spacing: 6) {
                        ForEach(0..<data.count, id: \.self) { i in
                            VStack(spacing: 6) {
                                if data[i].value > 0 {
                                    Text(String(format: "%.1f", data[i].value))
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(i == data.count - 1 ? accentGreen : Color.white.opacity(0.2))
                                    .frame(height: barHeight(for: data[i].value))
                                Text(data[i].label)
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 150)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: data.map(\.value))
                }
            }
            .padding(20)
        }
    }
    
    private var chartSubtitle: String {
        switch period {
        case .today: "By 4h slots"
        case .week: "By day"
        case .month: "By week"
        }
    }
    
    private func barHeight(for value: Double) -> CGFloat {
        guard maxValue > 0 else { return 4 }
        return max(4, CGFloat(value / maxValue) * 110)
    }
}
