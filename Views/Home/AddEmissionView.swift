//
//  AddEmissionView.swift
//  carbon
//
//  Created by Vedant Vijay on 08/02/26.
//

import SwiftUI

struct AddEmissionView: View {
    @Binding var showSheet: Bool
    @ObservedObject var emissionStore: EmissionStore
    
    @State private var selectedCategory: EmissionCategory? = nil
    @State private var selectedSubcategory: EmissionSubcategory? = nil
    @State private var inputValue: String = ""
    @State private var notes: String = ""
    @State private var step: Int = 1
    
    private let accentGreen = AppColors.accent
    
    var calculatedEmission: Double {
        guard let sub = selectedSubcategory,
              let val = Double(inputValue) else { return 0 }
        return val * sub.factor
    }
    
    var body: some View {
        ZStack {
            BackgroundView().ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Add Emission")
                                    .font(.system(size: 34, weight: .bold)).foregroundColor(.white)
                                Text("Calculate and log your carbon footprint")
                                    .font(.system(size: 16)).foregroundColor(.white.opacity(0.7))
                            }
                            Spacer()
                            Button(action: { showSheet = false }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6))
                                    .frame(width: 32, height: 32)
                                    .background(Circle().fill(Color.white.opacity(0.1)))
                            }
                            .accessibilityLabel("Close")
                        }
                        .padding(.top, 20).padding(.horizontal)
                        
                        StepIndicator(currentStep: step).padding(.horizontal)
                        
                        switch step {
                        case 1:
                            CategoryPickerView(selectedCategory: $selectedCategory, onSelect: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { step = 2 }
                            })
                            .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                                    removal: .move(edge: .leading).combined(with: .opacity)))
                        case 2:
                            if let category = selectedCategory {
                                SubcategoryPickerView(category: category, selectedSubcategory: $selectedSubcategory,
                                    onSelect: { withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { step = 3 } },
                                    onBack: { withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { step = 1; selectedCategory = nil } }
                                )
                                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                                        removal: .move(edge: .leading).combined(with: .opacity)))
                            }
                        case 3:
                            if let sub = selectedSubcategory {
                                EmissionInputView(subcategory: sub, inputValue: $inputValue, notes: $notes,
                                    calculatedEmission: calculatedEmission, onSave: saveEntry,
                                    onBack: { withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { step = 2; selectedSubcategory = nil; inputValue = "" } }
                                )
                                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                                        removal: .move(edge: .leading).combined(with: .opacity)))
                            }
                        default: EmptyView()
                        }
                        
                        Spacer().frame(height: 100)
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
            
        }
        .preferredColorScheme(.dark)
        .presentationBackground(Color(red: 0.06, green: 0.1, blue: 0.06))
        .onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
    }
    
    private func saveEntry() {
        guard let category = selectedCategory,
              let sub = selectedSubcategory,
              let val = Double(inputValue), val > 0 else { return }
        
        emissionStore.add(entry: EmissionEntry(
            category: category, subcategoryName: sub.name, subcategoryEmoji: sub.emoji,
            value: val, unit: sub.unit, calculatedKg: calculatedEmission, date: Date(), notes: notes
        ))
        showSheet = false
    }
}
