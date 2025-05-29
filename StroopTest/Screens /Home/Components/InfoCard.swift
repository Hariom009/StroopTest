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
