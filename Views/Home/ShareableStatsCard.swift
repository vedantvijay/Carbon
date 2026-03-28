//
//  ShareableStatsCard.swift
//  carbon
//
//  Created by Vedant Vijay on 26/02/26.
//

import SwiftUI

/// A minimalistic shareable stats card with a green glow that follows your finger.
struct ShareableStatsCard: View {
    @ObservedObject var emissionStore: EmissionStore
    
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    
    private let accent = AppColors.accent
    
    // Normalized drag (-1 to 1)
    private var nx: Double { min(max(dragOffset.width / 150, -1), 1) }
    private var ny: Double { min(max(dragOffset.height / 150, -1), 1) }
    
    private var topCategory: (category: EmissionCategory, total: Double)? {
        emissionStore.categoryBreakdown(since: 30).sorted { $0.total > $1.total }.first
    }
    
    private var dailyAvg: Double {
        let days = max(1, emissionStore.totalActiveDays)
        return emissionStore.monthlyTotal / Double(min(days, 30))
    }
    
    var body: some View {
        VStack(spacing: 28) {
            cardView
            
            Button(action: shareCard) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 15, weight: .semibold))
                    Text("Share")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(.black)
                .padding(.horizontal, 40)
                .padding(.vertical, 14)
                .background(Capsule().fill(accent))
            }
        }
    }
    
    // MARK: - Card View (3D tilt + moving glow)
    
    private var cardView: some View {
        cardContent
            .frame(width: 320, height: 440)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(.white.opacity(0.1), lineWidth: 1)
            )
            .rotation3DEffect(
                .degrees(nx * 12), axis: (x: 0, y: -1, z: 0), perspective: 0.4
            )
            .rotation3DEffect(
                .degrees(ny * 12), axis: (x: 1, y: 0, z: 0), perspective: 0.4
            )
            .shadow(
                color: accent.opacity(isDragging ? 0.3 : 0.15),
                radius: isDragging ? 30 : 12,
                x: -dragOffset.width / 10,
                y: -dragOffset.height / 10
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation(.interactiveSpring(response: 0.08, dampingFraction: 0.8)) {
                            dragOffset = value.translation
                            isDragging = true
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            dragOffset = .zero
                            isDragging = false
                        }
                    }
            )
            .animation(.interactiveSpring(response: 0.08, dampingFraction: 0.8), value: dragOffset)
            
            
    }
    
    // MARK: - Card Content
    
    private var cardContent: some View {
                 
        
        ZStack {
            // Pure black base
            Color.black
            
            // Green glow that moves with drag
            RadialGradient(
                colors: [accent.opacity(isDragging ? 0.35 : 0.2), .clear],
                center: UnitPoint(
                    x: 0.3 + nx * 0.35,
                    y: 0.25 + ny * 0.35
                ),
                startRadius: 10,
                endRadius: 300
            )
            
            // Content
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack(spacing: 10) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 18))
                        .foregroundColor(accent)
                    Text("Carbon")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Text(monthLabel)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(.white.opacity(0.08)))
                }
                .padding(.bottom, 24)
                
                // Big number
                HStack(alignment: .lastTextBaseline, spacing: 6) {
                    Text(String(format: "%.1f", emissionStore.monthlyTotal))
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("kg")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))
                }
                Text("CO₂ this month")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.bottom, 24)
                
                // Divider
                Rectangle().fill(.white.opacity(0.08)).frame(height: 1)
                    .padding(.bottom, 20)
                
                // Stats row
                HStack(spacing: 0) {
                    miniStat(icon: "sun.max.fill", value: String(format: "%.1f", emissionStore.todayTotal), label: "Today")
                    miniStat(icon: "calendar", value: String(format: "%.0f", emissionStore.weeklyTotal), label: "Week")
                    miniStat(icon: "flame.fill", value: "\(emissionStore.currentStreak)", label: "Streak")
                    miniStat(icon: "chart.line.uptrend.xyaxis", value: String(format: "%.1f", dailyAvg), label: "Avg/day")
                }
                .padding(.bottom, 20)
                
                // Divider
                Rectangle().fill(.white.opacity(0.08)).frame(height: 1)
                    .padding(.bottom, 20)
                
                // Bottom info
                HStack {
                    if let top = topCategory {
                        HStack(spacing: 6) {
                            Text(top.category.emoji).font(.system(size: 16))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(top.category.rawValue)
                                    .font(.system(size: 13, weight: .semibold)).foregroundColor(.white)
                                Text("Top category")
                                    .font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
                            }
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(emissionStore.totalActiveDays)")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(accent)
                        Text("days tracked")
                            .font(.system(size: 11)).foregroundColor(.white.opacity(0.4))
                    }
                }
                
                Spacer()
                
                // Footer
                HStack {
                    Text("🌱 Tracked with Carbon")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.25))
                    Spacer()
                    Text(Date(), style: .date)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.25))
                }
            }
            .padding(24)
        }
    }
    
    private func miniStat(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(accent.opacity(0.7))
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var monthLabel: String {
        let f = DateFormatter()
        f.dateFormat = "MMM yyyy"
        return f.string(from: Date())
    }
    
    // MARK: - Share
    
    @MainActor
    private func shareCard() {
        let renderer = ImageRenderer(content:
            cardContent
                .frame(width: 320, height: 440)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        )
        renderer.scale = 3.0
        
        guard let image = renderer.uiImage else { return }
        
        let activityVC = UIActivityViewController(
            activityItems: [image, "My carbon footprint this month 🌍🌱 #CarbonTracker"],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            var topVC = rootVC
            while let presented = topVC.presentedViewController { topVC = presented }
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = topVC.view
                popover.sourceRect = CGRect(x: topVC.view.bounds.midX, y: topVC.view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            topVC.present(activityVC, animated: true)
        }
    }
}

// MARK: - Preview

#Preview("Shareable Stats Card") {
    ZStack {
        Color.black.ignoresSafeArea()
        ShareableStatsCard(emissionStore: EmissionStore())
    }
}
