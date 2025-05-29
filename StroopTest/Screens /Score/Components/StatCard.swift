//
//  StatCard.swift
//  StroopTest
//
//  Created by Hari's Mac on 29.05.2025.
//

import Foundation
import SwiftUI

// Custom StatCard component for the report
struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let animatedValue: Int
    
    @State private var cardScale: CGFloat = 0.9
    @State private var cardOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .shadow(color: color.opacity(0.5), radius: 5)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [color.opacity(0.1), color.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
        .scaleEffect(cardScale)
        .opacity(cardOpacity)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double.random(in: 0...0.3))) {
                cardScale = 1.0
                cardOpacity = 1.0
            }
        }
    }
}
