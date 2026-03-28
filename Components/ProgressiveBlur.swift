//
//  ProgressiveBlur.swift
//  carbon
//
//  Created by Vedant Vijay on 22/02/26.
//

import SwiftUI

struct GradientBlurOverlay: View {
    var direction: Edge = .top
    
    var body: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .mask(
                LinearGradient(
                    colors: [.black, .clear],
                    startPoint: edge(direction),
                    endPoint: oppositeEdge(direction)
                )
            )
            .allowsHitTesting(false)
    }
    
    private func edge(_ edge: Edge) -> UnitPoint {
        switch edge {
        case .top: .top
        case .bottom: .bottom
        case .leading: .leading
        case .trailing: .trailing
        }
    }
    
    private func oppositeEdge(_ edge: Edge) -> UnitPoint {
        switch edge {
        case .top: .bottom
        case .bottom: .top
        case .leading: .trailing
        case .trailing: .leading
        }
    }
}

// MARK: - Preview

#Preview("Gradient Blur - Top") {
    ZStack {
        LinearGradient(
            colors: [.purple, .blue, .cyan, .green, .yellow, .orange, .red],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        ScrollView {
            VStack(spacing: 12) {
                ForEach(0..<30, id: \.self) { i in
                    Text("Line \(i) — The quick brown fox jumps over the lazy dog")
                        .font(.caption)
                        .foregroundStyle(.white)
                }
            }
            .padding()
        }
        
        VStack {
            GradientBlurOverlay(direction: .top)
                .frame(height: 80)
            Spacer()
        }
        .ignoresSafeArea()
    }
}
