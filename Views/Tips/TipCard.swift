//
//  TipCard.swift
//  carbon
//
//  Created by Vedant Vijay on 18/02/26.
//

import SwiftUI

struct TipCard: View {
    let tip: EcoTip
    @State private var isExpanded = false
    
    private let accent = AppColors.accent
    
    var body: some View {
        GlassmorphicCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { isExpanded.toggle() }
                } label: {
                    HStack(spacing: 14) {
                        Text(tip.emoji).font(.system(size: 28))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(tip.title)
                                .font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            Text(tip.impact)
                                .font(.system(size: 13, weight: .medium)).foregroundColor(accent)
                        }
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white.opacity(0.3))
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                }
                .buttonStyle(.plain)
                
                if isExpanded {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(tip.detail)
                            .font(.system(size: 14)).foregroundColor(.white.opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack(spacing: 8) {
                            Image(systemName: "leaf.fill").foregroundColor(accent).font(.system(size: 12))
                            Text("Annual savings: ~\(String(format: "%.0f", tip.annualSavingsKg)) kg CO₂")
                                .font(.system(size: 13, weight: .semibold)).foregroundColor(.white.opacity(0.7))
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(accent.opacity(0.1)))
                        
                        HStack(spacing: 6) {
                            Image(systemName: "book.closed.fill")
                                .foregroundColor(.white.opacity(0.3)).font(.system(size: 10))
                            Text(tip.source)
                                .font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(16)
        }
    }
}
