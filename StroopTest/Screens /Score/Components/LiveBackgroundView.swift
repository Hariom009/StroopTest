//
//  LiveBackgroundView.swift
//  StroopTest
//
//  Created by Hari's Mac on 30.05.2025.
//

import SwiftUI

struct LiveBackgroundView: View {
    @Binding var backgroundGradientOpacity: Double
    @Binding var particleAnimation: Bool
    var body: some View {
        // Animated background gradient
        LinearGradient(
            colors: [
                Color.purple.opacity(0.1),
                Color.blue.opacity(0.1),
                Color.black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .opacity(backgroundGradientOpacity)
        .ignoresSafeArea()
        
        // Floating particles effect
        ForEach(0..<20, id: \.self) { index in
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple, .cyan],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: CGFloat.random(in: 2...6))
                .position(
                    x: CGFloat.random(in: 50...350),
                    y: particleAnimation ? CGFloat.random(in: 100...700) : CGFloat.random(in: 200...600)
                )
                .opacity(particleAnimation ? 0.8 : 0.3)
                .animation(
                    .linear(duration: Double.random(in: 3...6))
                    .repeatForever(autoreverses: true)
                    .delay(Double.random(in: 0...2)),
                    value: particleAnimation
                )
        }
    }
}

#Preview {
    LiveBackgroundView(backgroundGradientOpacity: .constant(0.5), particleAnimation: .constant(true))
        .preferredColorScheme(.dark)
}
