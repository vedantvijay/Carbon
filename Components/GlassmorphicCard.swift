//
//  GlassmorphicCard.swift
//  carbon
//
//  Created by Vedant Vijay on 08/02/26.
//

import SwiftUI

struct GlassmorphicCard<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat
    
    init(cornerRadius: CGFloat = 24, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white.opacity(0.1))
                    .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(Color.white.opacity(0.2), lineWidth: 1))
            )
    }
}

#Preview {
    ZStack {
        Color.green.ignoresSafeArea()
        GlassmorphicCard {
            Text("Glass Card")
                .foregroundColor(.white)
                .padding(40)
        }
    }
}
