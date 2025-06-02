//
//  TestHistoryBG.swift
//  StroopTest
//
//  Created by Hari's Mac on 02.06.2025.
//

import SwiftUI

struct TestHistoryBG: View {
    @Binding var animateChart: Bool
    var body: some View {
        // Animated gradient background
        LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.05, blue: 0.12),
                Color(red: 0.1, green: 0.05, blue: 0.15),
                Color(red: 0.08, green: 0.1, blue: 0.18)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay {
            ForEach(0..<20, id: \.self) { i in
                Circle()
                    .fill(Color.purple.opacity(0.1))
                    .frame(width: CGFloat.random(in: 2...6))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        .easeInOut(duration: Double.random(in: 3...8))
                        .repeatForever(autoreverses: true),
                        value: animateChart
                    )
                    .scaleEffect(animateChart ? 1.5 : 0.5)
            }
        }
    }
}

#Preview {
    TestHistoryBG(animateChart: .constant(false))
}
