//
//  TestHistoryHeader.swift
//  StroopTest
//
//  Created by Hari's Mac on 02.06.2025.
//

import SwiftUI

struct TestHistoryHeader: View {
    @Binding var animateChart: Bool
    var body: some View {
        // Header with glow effect
        VStack(spacing: 8) {
            Text("Performance Analytics")
                .font(.title)
                .fontWeight(.black)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple, .pink, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: .purple.opacity(0.5), radius: 10)
            
            Text("Track your cognitive performance over time")
                .font(.caption)
                .foregroundColor(.gray)
                .opacity(animateChart ? 1 : 0)
                .animation(.easeInOut(duration: 1).delay(0.5), value: animateChart)
        }
        .padding(.top, 20)
    }
}

#Preview {
    TestHistoryHeader(animateChart: .constant(false))
}
