//
//  GradientTextView.swift
//  StroopTest
//
//  Created by Hari's Mac on 30.05.2025.
//

import SwiftUI

struct GradientTextView: View {
    @State var text: String
    @Binding var titleOpacity: Double
    var body: some View {
        VStack(spacing: 20) {
            Text("\(text)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .cyan, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .opacity(titleOpacity)
                .shadow(color: .blue.opacity(0.5), radius: 10)
                .multilineTextAlignment(.center)
            
            // Decorative line
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.clear, .blue, .purple, .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 2)
                .frame(maxWidth: titleOpacity > 0 ? 250 : 0)
                .animation(.easeInOut(duration: 1).delay(0.5), value: titleOpacity)
        }
    }
}

#Preview {
    GradientTextView(text: "Sample", titleOpacity: .constant(0.5))
}
