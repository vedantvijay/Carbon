//
//  HomeScreenView.swift
//  carbon
//
//  Created by Vedant Vijay on 07/02/26.
//

import SwiftUI

struct HomeScreenView: View {
    @Binding var selectedTab: Tab
    @Binding var showAddEmission: Bool
    @ObservedObject var emissionStore: EmissionStore
    @State private var showTips = false
    @State private var showShareCard = false
    @State private var showGoalSheet = false
    @Environment(\.useNativeTabBar) private var useNativeTabBar
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView().ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20) {
                            HeaderSection()
                            
                            NavigationLink {
                                ImpactDetailView(emissionStore: emissionStore)
                            } label: {
                                TodaysImpactCard(emissionStore: emissionStore)
                            }
                            .buttonStyle(.plain).padding(.horizontal)
                            
                            QuickActionsRow(selectedTab: $selectedTab, showAddEmission: $showAddEmission,
                                            onGoalTapped: { showGoalSheet = true },
                                            onTipsTapped: { showTips = true },
                                            onShareTapped: { showShareCard = true }).padding(.horizontal)
                            
                            StreakCard(emissionStore: emissionStore).padding(.horizontal)
                            ContributionGraphView(emissionStore: emissionStore).padding(.horizontal)
                            WeeklyChartCard(emissionStore: emissionStore).padding(.horizontal)
                            RecentActivitiesSection(emissionStore: emissionStore, selectedTab: $selectedTab).padding(.horizontal)
                            
                            if !useNativeTabBar {
                                Spacer().frame(height: 100)
                            }
                        }
                    }

                    if !useNativeTabBar {
                        CustomTabBar(selectedTab: $selectedTab, onAddTapped: { showAddEmission = true })
                    }
                }
                .ignoresSafeArea(edges: useNativeTabBar ? [] : .bottom)
                
                GeometryReader { proxy in
                    GradientBlurOverlay(direction: .top)
                        .frame(height: proxy.safeAreaInsets.top)
                        .ignoresSafeArea()
                }
            }
            .preferredColorScheme(.dark)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $showTips) {
                EcoTipsView(emissionStore: emissionStore)
            }
            .navigationDestination(isPresented: $showShareCard) {
                ZStack {
                    Color.black.ignoresSafeArea()
                    ShareableStatsCard(emissionStore: emissionStore)
                }
                .preferredColorScheme(.dark)
                .toolbarColorScheme(.dark, for: .navigationBar)
            }
            .sheet(isPresented: $showGoalSheet) {
                SetGoalView()
            }
        }
    }
}

// MARK: - Set Goal View

struct SetGoalView: View {
    @AppStorage("dailyGoal") private var dailyGoal: Double = 10.0
    @Environment(\.dismiss) private var dismiss
    @State private var sliderValue: Double = 10.0
    
    // Verified averages (Our World in Data, 2022 — tonnes CO₂/yr ÷ 365)
    private let globalAvg: Double = 12.8   // 4.7 t/yr → 12.8 kg/day
    private let usAvg: Double = 41.1       // 15.0 t/yr
    private let euAvg: Double = 16.4       // 6.0 t/yr
    private let indiaAvg: Double = 5.5     // 2.0 t/yr
    
    var body: some View {
        ZStack {
            BackgroundView().ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Handle
                    Capsule().fill(Color.white.opacity(0.3))
                        .frame(width: 40, height: 4).padding(.top, 12)
                    
                    // Header
                    Text("Daily CO₂ Goal")
                        .font(.system(size: 24, weight: .bold)).foregroundColor(.white)
                    
                    // Big number
                    VStack(spacing: 2) {
                        Text(String(format: "%.0f", sliderValue))
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .foregroundColor(AppColors.accent)
                            .contentTransition(.numericText())
                        Text("kg CO₂ per day")
                            .font(.system(size: 14, weight: .medium)).foregroundColor(.white.opacity(0.5))
                    }
                    
                    // How you compare
                    comparisonSection
                    
                    // Presets
                    HStack(spacing: 8) {
                        ForEach([5.0, 8.0, 10.0, 15.0, 20.0], id: \.self) { val in
                            Button(action: { withAnimation { sliderValue = val } }) {
                                Text("\(Int(val))")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(sliderValue == val ? .white : .white.opacity(0.5))
                                    .frame(width: 48, height: 40)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(sliderValue == val ? AppColors.accent : Color.white.opacity(0.08))
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    // Slider
                    VStack(spacing: 6) {
                        Slider(value: $sliderValue, in: 1...50, step: 1)
                            .tint(AppColors.accent)
                        HStack {
                            Text("1 kg").font(.system(size: 11)).foregroundColor(.white.opacity(0.3))
                            Spacer()
                            Text("50 kg").font(.system(size: 11)).foregroundColor(.white.opacity(0.3))
                        }
                    }
                    .padding(.horizontal)
                    
                    GlassmorphicCard(cornerRadius: 20) {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("That's equal to…")
                                .font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                            
                            impactRow(emoji: "🚗",
                                      text: "Driving \(String(format: "%.0f", sliderValue / 0.2)) km by car",
                                      source: "EPA · ~200 g CO₂/km avg new vehicle")
                            
                            impactRow(emoji: "🌳",
                                      text: "\(String(format: "%.0f", (sliderValue * 365) / 22)) trees needed to offset yearly",
                                      source: "EPA/USDA Forest Service · ~22 kg CO₂/tree/yr")
                            
                            impactRow(emoji: "📱",
                                      text: "\(String(format: "%.0f", sliderValue / 0.019)) smartphone full charges",
                                      source: "~7 kWh/yr ÷ 365 charges · ~19 g CO₂ each")
                            
                            impactRow(emoji: "✈️",
                                      text: "\(String(format: "%.1f", sliderValue / 0.16)) km of flying (economy)",
                                      source: "DEFRA 2024 · 160 g CO₂/passenger-km economy")
                        }
                        .padding(20)
                    }
                    .padding(.horizontal)
                    
                    // Save
                    Button(action: {
                        dailyGoal = sliderValue
                        dismiss()
                    }) {
                        Text("Set Goal")
                            .font(.system(size: 18, weight: .bold)).foregroundColor(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 18)
                            .background(Capsule().fill(AppColors.accent))
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
        }
        .presentationDetents([.large])
        .presentationBackground(Color(red: 0.06, green: 0.1, blue: 0.06))
        .onAppear { sliderValue = dailyGoal }
    }
    
    // MARK: - Comparison Section
    
    private var comparisonSection: some View {
        GlassmorphicCard(cornerRadius: 20) {
            VStack(alignment: .leading, spacing: 14) {
                Text("How you compare")
                    .font(.system(size: 16, weight: .bold)).foregroundColor(.white)
                
                comparisonBar(label: "🇮🇳 India avg", avg: indiaAvg)
                comparisonBar(label: "🌍 World avg", avg: globalAvg)
                comparisonBar(label: "🇪🇺 EU avg", avg: euAvg)
                comparisonBar(label: "🇺🇸 US avg", avg: usAvg)
                
                Text("Source: Our World in Data, 2022 · per-capita CO₂/day")
                    .font(.system(size: 10)).foregroundColor(.white.opacity(0.25))
            }
            .padding(20)
        }
        .padding(.horizontal)
    }
    
    private func comparisonBar(label: String, avg: Double) -> some View {
        let maxVal = max(usAvg, sliderValue) + 5
        let diff = ((avg - sliderValue) / avg) * 100
        
        return VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.system(size: 13, weight: .medium)).foregroundColor(.white.opacity(0.7))
                Spacer()
                if sliderValue < avg {
                    Text("\(String(format: "%.0f", abs(diff)))% below")
                        .font(.system(size: 12, weight: .bold)).foregroundColor(AppColors.accent)
                } else if sliderValue > avg {
                    Text("\(String(format: "%.0f", abs(diff)))% above")
                        .font(.system(size: 12, weight: .bold)).foregroundColor(.orange)
                } else {
                    Text("Same")
                        .font(.system(size: 12, weight: .bold)).foregroundColor(.white.opacity(0.5))
                }
            }
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.accent.opacity(0.08)).frame(height: 8)
                    
                    // Average bar
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.accent.opacity(0.25))
                        .frame(width: geo.size.width * min(avg / maxVal, 1.0), height: 8)
                    
                    // User's goal marker
                    let goalX = geo.size.width * min(sliderValue / maxVal, 1.0)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(sliderValue <= avg ? AppColors.accent : .orange)
                        .frame(width: 3, height: 14)
                        .offset(x: goalX - 1.5)
                }
            }
            .frame(height: 14)
        }
    }
    
    private func impactRow(emoji: String, text: String, source: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(emoji).font(.system(size: 22))
            VStack(alignment: .leading, spacing: 2) {
                Text(text)
                    .font(.system(size: 14, weight: .medium)).foregroundColor(.white)
                Text(source)
                    .font(.system(size: 11)).foregroundColor(.white.opacity(0.35))
            }
        }
    }
}
