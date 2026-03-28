//
//  OnboardingView.swift
//  carbon
//
//  Created by Vedant Vijay on 05/02/26.
//

import SwiftUI
import AnimateText

struct OnboardingView: View {
    @Binding var hasOnboarded: Bool
    @State private var page = 0
    @State private var titleText = ""
    
    let titles = ["Welcome to Carbon", "Track Everything", "Explore Products", "Grow Your Streak", "Share Your Impact"]
    let subtitles = [
        "Track your carbon footprint and make a real impact on the planet.",
        "Log meals, travel, energy usage, and shopping — see your CO₂ impact instantly.",
        "Search our product database to instantly check the carbon footprint of everyday items.",
        "Build daily habits, track consistency, and get personalized eco tips.",
        "Get a beautiful stats card you can share on social media and inspire others."
    ]
    let emojis = ["🌍", "📊", "🔍", "🌱", "✨"]
    let icons = ["leaf.fill", "chart.bar.fill", "leaf.circle", "flame.fill", "square.and.arrow.up"]
    
    var body: some View {
        ZStack {
            OnboardingBackground().ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 180, height: 180)
                    Text(emojis[page])
                        .font(.system(size: 56))
                }
                .padding(.bottom, 24)
                
                // Title with blur animation
                AnimateText<ATBlurEffect>($titleText, type: .letters)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(height: 36)
                
                // Subtitle
                Text(subtitles[page])
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                    .id(page)
                
                Spacer()
                
                // Page dots
                HStack(spacing: 8) {
                    ForEach(0..<5, id: \.self) { i in
                        Capsule()
                            .fill(i == page ? Color.green : Color.white.opacity(0.2))
                            .frame(width: i == page ? 24 : 8, height: 8)
                            .animation(.spring(), value: page)
                    }
                }
                
                // Continue button
                Button {
                    if page < 4 {
                        withAnimation { page += 1 }
                    } else {
                        hasOnboarded = true
                    }
                } label: {
                    Text(page == 4 ? "Get Started" : "Continue")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Capsule().fill(Color.green))
                }
                .padding(.top, 24)
                
                Spacer().frame(height: 50)
            }
            .padding(.horizontal, 24)
        }
        .preferredColorScheme(.dark)
        .onAppear { titleText = titles[page] }
        .onChange(of: page) { _, newPage in
            titleText = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                titleText = titles[newPage]
            }
        }
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.width < -50 && page < 4 { withAnimation { page += 1 } }
                if value.translation.width > 50 && page > 0 { withAnimation { page -= 1 } }
            }
        )
    }
}

#Preview {
    OnboardingView(hasOnboarded: .constant(false))
}
