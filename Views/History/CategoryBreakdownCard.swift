//
//  CategoryBreakdownCard.swift
//  carbon
//
//  Created by Vedant Vijay on 11/02/26.
//

import SwiftUI

struct CategoryBreakdownCard: View {
    let breakdown: [(category: EmissionCategory, total: Double)]
    let total: Double
    
    private let accentGreen = AppColors.accent
    private let categoryColors: [EmissionCategory: Color] = [
        .travel: AppColors.travel,
        .food: AppColors.food,
        .energy: AppColors.energy,
        .shopping: AppColors.shopping
    ]
    
    var body: some View {
        if !breakdown.isEmpty {
            GlassmorphicCard(cornerRadius: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "chart.pie.fill")
                            .foregroundColor(accentGreen).font(.system(size: 16))
                        Text("By Category")
                            .font(.system(size: 17, weight: .semibold)).foregroundColor(.white)
                    }
                    
                    GeometryReader { geo in
                        HStack(spacing: 2) {
                            ForEach(breakdown, id: \.category) { item in
                                let fraction = total > 0 ? item.total / total : 0
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(categoryColors[item.category] ?? .gray)
                                    .frame(width: max(8, geo.size.width * CGFloat(fraction)))
                            }
                        }
                    }
                    .frame(height: 10)
                    .clipShape(Capsule())
                    
                    ForEach(breakdown, id: \.category) { item in
                        HStack(spacing: 10) {
                            Circle()
                                .fill(categoryColors[item.category] ?? .gray)
                                .frame(width: 10, height: 10)
                            Text(item.category.emoji + " " + item.category.rawValue)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                            Text(String(format: "%.1f kg", item.total))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            let pct = total > 0 ? (item.total / total) * 100 : 0
                            Text(String(format: "%.0f%%", pct))
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.4))
                                .frame(width: 36, alignment: .trailing)
                        }
                    }
                }
                .padding(20)
            }
        }
    }
}
