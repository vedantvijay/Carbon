//
//  SegmentedPicker.swift
//  carbon
//
//  Created by Vedant Vijay on 09/02/26.
//

import SwiftUI

struct SegmentedPicker: View {
    @Binding var selected: TimePeriod
    @Namespace private var segmentNS
    
    private let accentGreen = AppColors.accent
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(TimePeriod.allCases, id: \.self) { period in
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selected = period
                    }
                }) {
                    Text(period.rawValue)
                        .font(.system(size: 14, weight: selected == period ? .semibold : .regular))
                        .foregroundColor(selected == period ? .white : .white.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background {
                            if selected == period {
                                Capsule()
                                    .fill(accentGreen.opacity(0.3))
                                    .matchedGeometryEffect(id: "segment", in: segmentNS)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Capsule().fill(Color.white.opacity(0.08)))
    }
}
