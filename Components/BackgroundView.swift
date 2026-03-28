//
//  BackgroundView.swift
//  carbon
//
//  Created by Vedant Vijay on 06/02/26.
//

import SwiftUI

struct BackgroundView: View {
   
    let startDate = Date()
    
    var body: some View {
        TimelineView(.animation) { timeline in
          
            let time = timeline.date.timeIntervalSince(startDate)
            
            ZStack {
                Color.black
                
                RadialGradient(
                    colors: [
                        Color(red: 0.2, green: 0.6, blue: 0.3),
                        Color.black
                    ],
                    center: UnitPoint(
                        x: 0.75 + offset1(time: time).x,
                        y: 0.15 + offset1(time: time).y
                    ),
                    startRadius: 50,
                    endRadius: 600
                )
                .blendMode(.screen)
                
                // Soft Lime Glow
                RadialGradient(
                    colors: [
                        Color(red: 0.7, green: 0.9, blue: 0.5),
                        Color.clear
                    ],
                    center: UnitPoint(
                        x: 0.7 + offset2(time: time).x,
                        y: 0.1 + offset2(time: time).y
                    ),
                    startRadius: 30,
                    endRadius: 500
                )
                .blendMode(.screen)
                
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.8),
                        Color.clear,
                        Color.black.opacity(0.8)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .ignoresSafeArea()
        .blur(radius: 80)
    }
    
    private func offset1(time: Double) -> CGPoint {
        let x = 0.18 * sin(time * 0.35)
              + 0.07 * sin(time * 1.2)
        
        let y = 0.03 * cos(time * 0.28)
              + 0.05 * sin(time * 0.9)
        
        return CGPoint(x: x, y: y)
    }
    
    private func offset2(time: Double) -> CGPoint {
        let x = -0.14 * cos(time * 0.22)
              + 0.06 * sin(time * 0.75)
        
        let y = 0.20 * sin(time * 0.4)
              + 0.04 * cos(time * 1.1)
        
        return CGPoint(x: x, y: y)
    }
}

#Preview {
    BackgroundView()
}
