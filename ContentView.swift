//
//  ContentView.swift
//  carbon
//
//  Created by Vedant Vijay on 05/02/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var showAddEmission = false
    @StateObject private var emissionStore = EmissionStore()
    @StateObject private var gratitudeStore = GratitudeStore()
    @AppStorage("hasOnboarded") private var hasOnboarded = false
    
    var body: some View {
        if !hasOnboarded {
            OnboardingView(hasOnboarded: $hasOnboarded)
        } else {
            mainContent
                .sheet(isPresented: $showAddEmission) {
                    AddEmissionView(showSheet: $showAddEmission, emissionStore: emissionStore)
                }
        }
    }
    
    @ViewBuilder
    private var mainContent: some View {
        // On iOS 26+, the system TabView automatically renders with Liquid Glass.
        // On older iOS, these same views still embed the CustomTabBar internally.
        // We use useNativeTabBar environment to tell views whether to hide their
        // embedded CustomTabBar when running inside this native TabView.
        if isLiquidGlassAvailable {
            nativeTabView
        } else {
            legacyTabView
        }
    }
    
    /// True when running on iOS 26+ where TabView gets Liquid Glass styling.
    private var isLiquidGlassAvailable: Bool {
        if #available(iOS 26, *) {
            return true
        }
        return false
    }
    
    // MARK: - Native TabView (Liquid Glass on iOS 26+)
    
    private var nativeTabView: some View {
        TabView(selection: $selectedTab) {
            HomeScreenView(selectedTab: $selectedTab, showAddEmission: $showAddEmission, emissionStore: emissionStore)
                .tabItem { Label("Home", systemImage: "house") }
                .tag(Tab.home)
            
            ProductLookupView(selectedTab: $selectedTab, showAddEmission: $showAddEmission, emissionStore: emissionStore)
                .tabItem { Label("Products", systemImage: "leaf.circle") }
                .tag(Tab.products)
            
            HistoryView(selectedTab: $selectedTab, showAddEmission: $showAddEmission, emissionStore: emissionStore)
                .tabItem { Label("History", systemImage: "clock.arrow.circlepath") }
                .tag(Tab.history)
            
            GratitudeView(selectedTab: $selectedTab, showAddEmission: $showAddEmission, gratitudeStore: gratitudeStore)
                .tabItem { Label("Journal", systemImage: "book.closed") }
                .tag(Tab.gratitude)
        }
        .tint(AppColors.accent)
        .environment(\.useNativeTabBar, true)
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Legacy Custom Tab Bar (iOS < 26)
    
    private var legacyTabView: some View {
        Group {
            switch selectedTab {
            case .home:
                HomeScreenView(selectedTab: $selectedTab, showAddEmission: $showAddEmission, emissionStore: emissionStore)
            case .products:
                ProductLookupView(selectedTab: $selectedTab, showAddEmission: $showAddEmission, emissionStore: emissionStore)
            case .history:
                HistoryView(selectedTab: $selectedTab, showAddEmission: $showAddEmission, emissionStore: emissionStore)
            case .gratitude:
                GratitudeView(selectedTab: $selectedTab, showAddEmission: $showAddEmission, gratitudeStore: gratitudeStore)
            }
        }
        .animation(.smooth(duration: 0.3), value: selectedTab)
    }
}

#Preview {
    ContentView()
}
