//
//  CustomTabBar.swift
//  carbon
//
//  Created by Vedant Vijay on 07/02/26.
//

import SwiftUI

enum Tab: Int, CaseIterable {
    case home = 0
    case products = 1
    case history = 2
    case gratitude = 3
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    var onAddTapped: () -> Void
    @Namespace private var tabNamespace
    
    private let accentGreen = AppColors.accent
    
    var body: some View {
        HStack(spacing: 0) {
            // Home
            TabBarItem(icon: "house", title: "Home", isSelected: selectedTab == .home, namespace: tabNamespace) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    selectedTab = .home
                }
            }
            
            // Products
            TabBarItem(icon: "leaf.circle", title: "Products", isSelected: selectedTab == .products, namespace: tabNamespace) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    selectedTab = .products
                }
            }
            
            // Center Add button
            Button(action: onAddTapped) {
                VStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(accentGreen)
                            .frame(width: 48, height: 48)
                            .shadow(color: accentGreen.opacity(0.4), radius: 8, y: 2)
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .offset(y: -8)
                    
                    Text("Add")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(accentGreen)
                        .offset(y: -8)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(TabButtonStyle())
            .accessibilityLabel("Add emission")
            
            // History
            TabBarItem(icon: "clock.arrow.circlepath", title: "History", isSelected: selectedTab == .history, namespace: tabNamespace) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    selectedTab = .history
                }
            }
            
            // Journal
            TabBarItem(icon: "book.closed", title: "Journal", isSelected: selectedTab == .gratitude, namespace: tabNamespace) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                    selectedTab = .gratitude
                }
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 20)
        .background(
            Color(red: 0.3, green: 0.38, blue: 0.28)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: -5)
        )
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    var namespace: Namespace.ID
    var onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .symbolVariant(isSelected ? .fill : .none)
                    .foregroundStyle(isSelected ? AppColors.accent : Color.white.opacity(0.5))
                    .scaleEffect(isSelected ? 1.15 : 1.0)
                
                Text(title)
                    .font(.system(size: 12, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? AppColors.accent : Color.white.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(TabButtonStyle())
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct TabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.88 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
