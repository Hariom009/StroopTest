//
//  InfoCard.swift
//  StroopTest
//
//  Created by Hari's Mac on 29.05.2025.
//

import Foundation
import SwiftUI
// Reusable Info Card Component
struct InfoCard: View {
    let title: String
    let content: String
    let stroopviewColor = Color(red: 0.2, green: 0.3, blue: 0.4)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(stroopviewColor)
            
            Text(content)
                .font(.system(size: 14))
                .foregroundColor(stroopviewColor)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.7))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct PremiumInfoCard: View {
    let icon: String
    let title: String
    let content: String
    let gradient: [Color]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Text(icon)
                    .font(.system(size: 24))
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Text(content)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(24)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            }
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}
