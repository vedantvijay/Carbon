//
//  AddJournalEntryView.swift
//  carbon
//
//  Created by Vedant Vijay on 17/02/26.
//

import SwiftUI

struct AddGratitudeView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var store: GratitudeStore
    
    @State private var emoji: String = "🌱"
    @State private var impactText: String = ""
    @State private var description: String = ""
    
    let suggestedEmojis = ["🌱", "🚴", "♻️", "💧", "🔋", "💡", "🥬", "🚌", "🌞", "🚶"]
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView().ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Emoji Picker
                        GlassmorphicCard(cornerRadius: 20) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Category Emoji")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(suggestedEmojis, id: \.self) { suggested in
                                            Button(action: { emoji = suggested }) {
                                                Text(suggested)
                                                    .font(.system(size: 32))
                                                    .padding(12)
                                                    .background(
                                                        Circle()
                                                            .fill(emoji == suggested ? AppColors.accent.opacity(0.3) : Color.white.opacity(0.08))
                                                    )
                                                    .overlay(
                                                        Circle()
                                                            .stroke(emoji == suggested ? AppColors.accent : Color.clear, lineWidth: 1.5)
                                                    )
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(20)
                        }
                        
                        // Impact Input
                        GlassmorphicCard(cornerRadius: 20) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Impact Estimate (kg CO₂ saved)")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                TextField("e.g. 1.5", text: $impactText)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.08)))
                                    .foregroundColor(.white)
                                    .accentColor(AppColors.accent)
                            }
                            .padding(20)
                        }
                        
                        // Description Input
                        GlassmorphicCard(cornerRadius: 20) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("What did you do today?")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                TextEditor(text: $description)
                                    .frame(height: 120)
                                    .padding(4)
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.08)))
                                    .foregroundColor(.white)
                                    .accentColor(AppColors.accent)
                                    .scrollContentBackground(.hidden)
                            }
                            .padding(20)
                        }
                        
                        // Save Button
                        Button(action: save) {
                            Text("Save Entry")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    Capsule()
                                        .fill(isFormValid ? AppColors.accent : Color.gray.opacity(0.5))
                                )
                        }
                        .disabled(!isFormValid)
                        .padding(.top, 8)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.white)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onTapGesture { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
    }
    
    private var isFormValid: Bool {
        !description.trimmingCharacters(in: .whitespaces).isEmpty &&
        Double(impactText.replacingOccurrences(of: ",", with: ".")) != nil
    }
    
    private func save() {
        let impactValue = Double(impactText.replacingOccurrences(of: ",", with: ".")) ?? 0.0
        let newEntry = GratitudeEntry(
            date: Date(),
            impact: impactValue,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            emoji: emoji
        )
        store.add(entry: newEntry)
        dismiss()
    }
}
