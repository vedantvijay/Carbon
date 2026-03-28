//
//  JournalView.swift
//  carbon
//
//  Created by Vedant Vijay on 15/02/26.
//

import SwiftUI

struct GratitudeView: View {
    @Binding var selectedTab: Tab
    @Binding var showAddEmission: Bool
    @State private var dailyQuote: String = ""
    @ObservedObject var gratitudeStore: GratitudeStore
    @State private var showAddEntry = false
    @Environment(\.useNativeTabBar) private var useNativeTabBar
    
    let quotes = [
        "Every sustainable choice, no matter how small, creates ripples of positive change for our planet.",
        "The Earth is what we all have in common. Let's protect it together.",
        "Small acts of conservation multiply when people do them around the world.",
        "We do not inherit the earth from our ancestors, we borrow it from our children.",
        "The environment is where we all meet; where we all have a mutual interest.",
        "Progress is not measured by what we consume, but by what we preserve.",
        "He that plants trees loves others beside himself.",
        "There is no such thing as 'away'. When we throw anything away it must go somewhere.",
        "Nature provides a free lunch, but only if we control our appetites.",
        "A true conservationist is a man who knows that the world is not given by his fathers, but borrowed from his children."
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Journal")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(.white)
                            Text("Reflect on your eco-friendly choices")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.top, 20)
                        .padding(.horizontal)
                        
                        // Daily Reflection Card
                        GlassmorphicCard(cornerRadius: 24) {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.9, green: 0.8, blue: 0.8).opacity(0.3))
                                            .frame(width: 48, height: 48)
                                        Image(systemName: "sparkles")
                                            .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.6))
                                            .font(.system(size: 20, weight: .semibold))
                                    }
                                    
                                    Text("Daily Reflection")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                Text("\"\(dailyQuote)\"")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineSpacing(4)
                            }
                            .padding(24)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal)
                        
                        // Stats Row
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Total Entries",
                                value: "\(gratitudeStore.totalEntries)",
                                unit: "",
                                icon: "heart",
                                iconColor: Color(red: 1.0, green: 0.4, blue: 0.4),
                                iconBg: Color(red: 1.0, green: 0.4, blue: 0.4).opacity(0.2)
                            )
                            
                            StatCard(
                                title: "Impact Saved",
                                value: String(format: "%.1f", gratitudeStore.totalImpactSaved),
                                unit: "kg",
                                icon: "leaf",
                                iconColor: AppColors.accent,
                                iconBg: AppColors.accent.opacity(0.2)
                            )
                        }
                        .padding(.horizontal)
                        
                        // Add Button
                        Button(action: {
                            showAddEntry = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .medium))
                                Text("Add Entry")
                                    .font(.system(size: 16, weight: .bold))
                            }
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(red: 0.0, green: 0.8, blue: 0.5)))
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                        
                        // Journey Header
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .foregroundColor(AppColors.accent)
                                .font(.system(size: 20))
                            Text("Your Journey")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        
                        // Dynamic Journey Cards
                        if gratitudeStore.entries.isEmpty {
                            Text("No entries yet. Add your first journal entry above!")
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.horizontal)
                                .padding(.top, 8)
                        } else {
                            ForEach(gratitudeStore.entries) { entry in
                                JourneyCard(
                                    emoji: entry.emoji,
                                    time: entry.formattedDate,
                                    impact: "Saved \(String(format: "%.1f", entry.impact)) kg CO₂",
                                    description: entry.description,
                                    impactColor: Color(red: 0.0, green: 0.8, blue: 0.5)
                                )
                                .padding(.horizontal)
                            }
                        }
                        
                        if !useNativeTabBar {
                            Spacer()
                                .frame(height: 100)
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
        .onAppear {
            setDailyQuote()
        }
        .sheet(isPresented: $showAddEntry) {
            AddGratitudeView(store: gratitudeStore)
        }
    }
    
    private func setDailyQuote() {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let quoteIndex = dayOfYear % quotes.count
        dailyQuote = quotes[quoteIndex]
    }
}

struct JourneyCard: View {
    let emoji: String
    let time: String
    let impact: String
    let description: String
    let impactColor: Color
    
    var body: some View {
        GlassmorphicCard(cornerRadius: 16) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center) {
                    Text(emoji)
                        .font(.system(size: 24))
                        .padding(8)
                        .background(Circle().fill(Color.white.opacity(0.1)))
                    
                    Text(time)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.leading, 4)
                    
                    Spacer()
                    
                    Text(impact)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(impactColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(impactColor.opacity(0.2)))
                }
                
                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.9))
                    .lineSpacing(4)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    GratitudeView(selectedTab: .constant(.gratitude), showAddEmission: .constant(false), gratitudeStore: GratitudeStore())
}
