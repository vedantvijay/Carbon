//
//  ProductResultView.swift
//  carbon
//
//  Created by Vedant Vijay on 16/02/26.
//

import SwiftUI

// MARK: - Scan Result View

struct ScanResultView: View {
    let product: ScannedProduct
    var onLogEmission: () -> Void
    var onScanAgain: () -> Void
    
    private let accentGreen = AppColors.accent
    
    @State private var appeared = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Product Card
            GlassmorphicCard(cornerRadius: 24) {
                VStack(spacing: 20) {
                    // Emoji + Name
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(impactGradient.opacity(0.2))
                                .frame(width: 56, height: 56)
                            Text(product.emoji)
                                .font(.system(size: 28))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.name)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            Text(product.brand)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        Spacer()
                    }
                    
                    // Carbon Impact
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Carbon Footprint")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.5))
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text(product.formattedCarbon)
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.white)
                                Text("CO₂")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                        
                        Spacer()
                        
                        // Impact badge
                        VStack(spacing: 6) {
                            ImpactDotsView(rating: product.impactRating)
                            Text(product.impactLabel)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(impactColor)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(impactColor.opacity(0.15))
                        )
                    }
                    
                    // Context comparison
                    HStack(spacing: 12) {
                        ComparisonBubble(
                            icon: "car.fill",
                            value: String(format: "%.1f km", product.carbonKg / 0.21),
                            label: "driving"
                        )
                        ComparisonBubble(
                            icon: "bolt.fill",
                            value: String(format: "%.0f hrs", product.carbonKg / 0.05),
                            label: "of LED light"
                        )
                        ComparisonBubble(
                            icon: "tree.fill",
                            value: String(format: "%.0f min", product.carbonKg / 0.022 * 60),
                            label: "tree absorb"
                        )
                    }
                }
                .padding(24)
            }
            .scaleEffect(appeared ? 1 : 0.9)
            .opacity(appeared ? 1 : 0)
            
            // Eco Tip
            GlassmorphicCard(cornerRadius: 20) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(accentGreen.opacity(0.2))
                            .frame(width: 40, height: 40)
                        Image(systemName: "leaf.fill")
                            .foregroundColor(accentGreen)
                            .font(.system(size: 18))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Eco Tip")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(accentGreen)
                        Text(product.tip)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.85))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .scaleEffect(appeared ? 1 : 0.9)
            .opacity(appeared ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1), value: appeared)
            
            // Actions
            HStack(spacing: 14) {
                Button(action: onScanAgain) {
                    HStack(spacing: 8) {
                        Image(systemName: "viewfinder")
                            .font(.system(size: 16, weight: .bold))
                        Text("Back to Search")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Capsule().fill(Color.white.opacity(0.15))
                    )
                }
                
                Button(action: onLogEmission) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16, weight: .bold))
                        Text("Log This")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Capsule().fill(accentGreen)
                    )
                }
            }
            .scaleEffect(appeared ? 1 : 0.9)
            .opacity(appeared ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.2), value: appeared)
        }
        .onAppear { appeared = true }
    }
    
    private var impactColor: Color {
        switch product.impactRating {
        case 1: return .green
        case 2: return .mint
        case 3: return .yellow
        case 4: return .orange
        default: return .red
        }
    }
    
    private var impactGradient: Color {
        impactColor
    }
}

// MARK: - Impact Dots

struct ImpactDotsView: View {
    let rating: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { i in
                Circle()
                    .fill(i <= rating ? dotColor : Color.white.opacity(0.15))
                    .frame(width: 8, height: 8)
            }
        }
    }
    
    private var dotColor: Color {
        switch rating {
        case 1: return .green
        case 2: return .mint
        case 3: return .yellow
        case 4: return .orange
        default: return .red
        }
    }
}

// MARK: - Comparison Bubble

struct ComparisonBubble: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.5))
                .font(.system(size: 14))
            Text(value)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.06))
        )
    }
}


