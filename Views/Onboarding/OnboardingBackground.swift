//
//  OnboardingBackground.swift
//  carbon
//
//  Created by Vedant Vijay on 05/02/26.
//

import SwiftUI

/// Smooth animated background for onboarding using the brand palette.
/// Creates a rich color wash instead of distinct blobs — the three colors
/// blend into each other across the full screen.
struct OnboardingBackground: View {
    let startDate = Date()
    
    private let dark  = Color(red: 0.075, green: 0.078, blue: 0.078)
    private let olive = Color(red: 0.267, green: 0.384, blue: 0.106)
    private let gold  = Color(red: 0.839, green: 0.757, blue: 0.557)
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSince(startDate)
            
            Canvas { context, size in
                // Fill base
                context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(dark))
                
                // Olive glow — upper area
                let olive1 = CGPoint(
                    x: size.width * (0.3 + 0.08 * sin(t * 0.25)),
                    y: size.height * (0.2 + 0.06 * cos(t * 0.3))
                )
                context.drawLayer { ctx in
                    ctx.addFilter(.blur(radius: 120))
                    ctx.fill(
                        Circle().path(in: CGRect(x: olive1.x - 200, y: olive1.y - 200, width: 400, height: 400)),
                        with: .color(olive.opacity(0.5))
                    )
                }
                
                // Gold glow — lower-right area
                let gold1 = CGPoint(
                    x: size.width * (0.72 + 0.07 * cos(t * 0.2)),
                    y: size.height * (0.75 + 0.05 * sin(t * 0.35))
                )
                context.drawLayer { ctx in
                    ctx.addFilter(.blur(radius: 130))
                    ctx.fill(
                        Circle().path(in: CGRect(x: gold1.x - 220, y: gold1.y - 220, width: 440, height: 440)),
                        with: .color(gold.opacity(0.35))
                    )
                }
                
                // Subtle olive accent — center, ties the two together
                let mid = CGPoint(
                    x: size.width * (0.5 + 0.05 * sin(t * 0.15)),
                    y: size.height * (0.45 + 0.04 * cos(t * 0.2))
                )
                context.drawLayer { ctx in
                    ctx.addFilter(.blur(radius: 150))
                    ctx.fill(
                        Circle().path(in: CGRect(x: mid.x - 180, y: mid.y - 180, width: 360, height: 360)),
                        with: .color(olive.opacity(0.15))
                    )
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingBackground()
}
