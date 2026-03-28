//
//  EmissionPickers.swift
//  carbon
//
//  Created by Vedant Vijay on 08/02/26.
//

import SwiftUI

struct StepIndicator: View {
    let currentStep: Int
    private let accentGreen = AppColors.accent
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...3, id: \.self) { i in
                HStack(spacing: 6) {
                    Circle()
                        .fill(i <= currentStep ? accentGreen : Color.white.opacity(0.2))
                        .frame(width: 10, height: 10)
                    if i < 3 {
                        Rectangle()
                            .fill(i < currentStep ? accentGreen : Color.white.opacity(0.15))
                            .frame(height: 2)
                    }
                }
            }
        }
        .animation(.smooth(duration: 0.3), value: currentStep)
        .accessibilityLabel("Step \(currentStep) of 3")
    }
}

struct CategoryPickerView: View {
    @Binding var selectedCategory: EmissionCategory?
    var onSelect: () -> Void
    let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select Category")
                .font(.system(size: 20, weight: .bold)).foregroundColor(.white)
                .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(EmissionCategory.allCases) { category in
                    Button(action: { selectedCategory = category; onSelect() }) {
                        GlassmorphicCard(cornerRadius: 20) {
                            VStack(spacing: 12) {
                                Text(category.emoji).font(.system(size: 40))
                                Text(category.rawValue)
                                    .font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                                Text("\(category.subcategories.count) types")
                                    .font(.system(size: 12)).foregroundColor(.white.opacity(0.5))
                            }
                            .frame(maxWidth: .infinity).padding(.vertical, 24)
                        }
                    }
                    .buttonStyle(TabButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }
}

struct SubcategoryPickerView: View {
    let category: EmissionCategory
    @Binding var selectedSubcategory: EmissionSubcategory?
    var onSelect: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppColors.accent)
                }
                .accessibilityLabel("Back")
                Text(category.emoji).font(.system(size: 24))
                Text(category.rawValue)
                    .font(.system(size: 20, weight: .bold)).foregroundColor(.white)
            }
            .padding(.horizontal)
            
            VStack(spacing: 10) {
                ForEach(category.subcategories) { sub in
                    Button(action: { selectedSubcategory = sub; onSelect() }) {
                        GlassmorphicCard(cornerRadius: 16) {
                            HStack(spacing: 14) {
                                Text(sub.emoji).font(.system(size: 28)).frame(width: 44)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(sub.name)
                                        .font(.system(size: 16, weight: .semibold)).foregroundColor(.white)
                                    Text("\(String(format: "%.3g", sub.factor)) kg CO₂ per \(sub.unit)")
                                        .font(.system(size: 13)).foregroundColor(.white.opacity(0.5))
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.3))
                            }
                            .padding(.horizontal, 16).padding(.vertical, 14)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}
