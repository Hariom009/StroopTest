//
//  GlowingEmojiView.swift
//  StroopTest
//
//  Created by Hari's Mac on 30.05.2025.
//

import Foundation
import SwiftUI

struct GlowingEmojiView: View {
    @State var text: String
    @Binding var celebrationScale: CGFloat
    @Binding var glowEffect: Bool
    var body: some View {
        Text("\(text)")
            .font(.system(size: 100))
            .scaleEffect(celebrationScale)
            .shadow(color: .yellow.opacity(0.8), radius: glowEffect ? 20 : 5)
            .animation(
                .spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.3),
                value: celebrationScale
            )
            .animation(
                .easeInOut(duration: 2)
                .repeatForever(autoreverses: true),
                value: glowEffect
            )
    }
}
