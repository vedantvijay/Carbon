//
//  HistoryView.swift
//  carbon
//
//  Created by Vedant Vijay on 10/02/26.
//

import SwiftUI

enum TimePeriod: String, CaseIterable {
    case today = "Today"
    case week = "This Week"
    case month = "This Month"
    
    var days: Int {
        switch self {
        case .today: 0
        case .week: 7
        case .month: 30
        }
    }
}

struct HistoryView: View {
    @Binding var selectedTab: Tab
    @Binding var showAddEmission: Bool
    @ObservedObject var emissionStore: EmissionStore
    @State private var selectedPeriod: TimePeriod = .today
    @Environment(\.useNativeTabBar) private var useNativeTabBar
    
    private var totalForPeriod: Double {
        switch selectedPeriod {
        case .today: emissionStore.todayTotal
        case .week: emissionStore.weeklyTotal
        case .month: emissionStore.monthlyTotal
        }
    }
    
    private var chartData: [(label: String, value: Double)] {
        switch selectedPeriod {
        case .today: emissionStore.todayHourlyData()
        case .week: emissionStore.weeklyDailyData()
        case .month: emissionStore.monthlyWeeklyData()
        }
    }
    
    var body: some View {
        ZStack {
            BackgroundView().ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("History")
                                .font(.system(size: 34, weight: .bold)).foregroundColor(.white)
                            Text("Your carbon emission log")
                                .font(.system(size: 16)).foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.top, 20).padding(.horizontal)
                        
                        SegmentedPicker(selected: $selectedPeriod).padding(.horizontal)
                        PeriodTotalCard(period: selectedPeriod, total: totalForPeriod).padding(.horizontal)
                        BarChartCard(data: chartData, period: selectedPeriod).padding(.horizontal)
                        
                        CategoryBreakdownCard(
                            breakdown: emissionStore.categoryBreakdown(since: selectedPeriod.days == 0 ? 1 : selectedPeriod.days),
                            total: totalForPeriod
                        ).padding(.horizontal)
                        
                        let filtered = emissionStore.entries(forPeriod: selectedPeriod.days)
                        if filtered.isEmpty {
                            EmptyHistoryView(showAddEmission: $showAddEmission).padding(.horizontal)
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Activity Log")
                                    .font(.system(size: 20, weight: .bold)).foregroundColor(.white)
                                    .padding(.horizontal)
                                ForEach(filtered) { entry in
                                    HistoryEntryRow(entry: entry)
                                }
                            }
                        }
                        
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
    }
}
