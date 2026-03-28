//
//  EmissionInput.swift
//  carbon
//
//  Created by Vedant Vijay on 08/02/26.
//

import SwiftUI

struct EmissionInputView: View {
    let subcategory: EmissionSubcategory
    @Binding var inputValue: String
    @Binding var notes: String
    let calculatedEmission: Double
    var onSave: () -> Void
    var onBack: () -> Void
    
    private let accentGreen = AppColors.accent
    @FocusState private var isValueFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 10) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold)).foregroundColor(accentGreen)
                }
                .accessibilityLabel("Back")
                Text(subcategory.emoji).font(.system(size: 24))
                Text(subcategory.name)
                    .font(.system(size: 20, weight: .bold)).foregroundColor(.white)
            }
            .padding(.horizontal)
            
            // Result card
            GlassmorphicCard(cornerRadius: 24) {
                VStack(spacing: 16) {
                    Text("CO₂ Emission")
                        .font(.system(size: 14, weight: .medium)).foregroundColor(.white.opacity(0.6))
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(String(format: "%.1f", calculatedEmission))
                            .font(.system(size: 56, weight: .bold)).foregroundColor(accentGreen)
                            .contentTransition(.numericText())
                        Text("kg")
                            .font(.system(size: 22, weight: .medium)).foregroundColor(.white.opacity(0.6))
                    }
                    .animation(.smooth(duration: 0.2), value: calculatedEmission)
                    if calculatedEmission > 0 { impactLabel }
                }
                .frame(maxWidth: .infinity).padding(24)
            }
            .padding(.horizontal)
            
            // Amount input
            GlassmorphicCard(cornerRadius: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Amount (\(subcategory.unit))")
                        .font(.system(size: 14, weight: .medium)).foregroundColor(.white.opacity(0.6))
                    HStack {
                        TextField("0", text: $inputValue)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 28, weight: .bold)).foregroundColor(.white)
                            .focused($isValueFocused)
                        Text(subcategory.unit)
                            .font(.system(size: 16, weight: .medium)).foregroundColor(.white.opacity(0.4))
                    }
                }
                .padding(20)
            }
            .padding(.horizontal)
            
            // Notes
            GlassmorphicCard(cornerRadius: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Notes (optional)")
                        .font(.system(size: 14, weight: .medium)).foregroundColor(.white.opacity(0.6))
                    TextField("e.g. Commute to work", text: $notes)
                        .font(.system(size: 16)).foregroundColor(.white)
                }
                .padding(20)
            }
            .padding(.horizontal)
            
            // Save
            Button(action: onSave) {
                HStack(spacing: 10) {
                    Image(systemName: "plus.circle.fill").font(.system(size: 20))
                    Text("Add to History").font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 18)
                .background(Capsule().fill(calculatedEmission > 0 ? accentGreen : Color.white.opacity(0.15)))
            }
            .disabled(calculatedEmission <= 0).padding(.horizontal).buttonStyle(.plain)
        }
        .onAppear { isValueFocused = true }
    }
    
    @ViewBuilder
    var impactLabel: some View {
        let level: (text: String, color: Color) = {
            if calculatedEmission < 2 { return ("Low Impact 🌿", Color.green) }
            else if calculatedEmission < 5 { return ("Moderate Impact 🌤️", Color.orange) }
            else { return ("High Impact 🔴", Color.red) }
        }()
        Text(level.text)
            .font(.system(size: 14, weight: .medium)).foregroundColor(level.color)
            .padding(.horizontal, 14).padding(.vertical, 6)
            .background(Capsule().fill(level.color.opacity(0.15)))
    }
}

