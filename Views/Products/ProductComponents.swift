//
//  ProductComponents.swift
//  carbon
//
//  Created by Vedant Vijay on 16/02/26.
//

import SwiftUI


struct ProductListRow: View {
    let product: ScannedProduct
    
    var body: some View {
        GlassmorphicCard(cornerRadius: 16) {
            HStack(spacing: 14) {
                Text(product.emoji).font(.system(size: 24))
                VStack(alignment: .leading, spacing: 3) {
                    Text(product.name)
                        .font(.system(size: 15, weight: .semibold)).foregroundColor(.white)
                    Text(product.brand)
                        .font(.system(size: 12)).foregroundColor(.white.opacity(0.5))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text(product.formattedCarbon)
                        .font(.system(size: 14, weight: .bold)).foregroundColor(.white)
                    Text("CO₂")
                        .font(.system(size: 10)).foregroundColor(.white.opacity(0.4))
                }
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.3)).font(.system(size: 12, weight: .bold))
            }
            .padding(16)
        }
    }
}

struct TipRow: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle().fill(AppColors.accent)
                .frame(width: 4, height: 4).padding(.top, 8)
            Text(text).font(.system(size: 14)).foregroundColor(.white.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

