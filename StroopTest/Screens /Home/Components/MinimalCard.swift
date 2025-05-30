//
//  MinimalCard.swift
//  StroopTest
//
//  Created by Hari's Mac on 30.05.2025.
//

import Foundation
import SwiftUI

struct MinimalCard: View {
    let number: String
    let title: String
    let description: String
    let delay: Double
    @State private var isVisible = false
    @State private var borderGlow = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            // Minimal number indicator
            Text(number)
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(.white.opacity(0.3))
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(.white.opacity(0.9))
                
                Text(description)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white.opacity(0.5))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.015))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            Color.white.opacity(borderGlow ? 0.08 : 0.03),
                            lineWidth: 0.5
                        )
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: borderGlow)
                )
        )
        .scaleEffect(isVisible ? 1 : 0.95)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 10)
        .animation(.spring(response: 1.0, dampingFraction: 0.8).delay(delay), value: isVisible)
        .onAppear {
            isVisible = true
            borderGlow = true
        }
    }
}
