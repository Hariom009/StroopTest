//
//  TestHistoryCard.swift
//  StroopTest
//
//  Created by Hari's Mac on 02.06.2025.
//

import SwiftUI
struct TestHistoryCard: View {
    let score: Score
    let rank: Int
    let isHighest: Bool
    let animationDelay: Double
    
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank indicator with glow
            ZStack {
                Circle()
                    .fill(
                        isHighest ?
                        LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom) :
                        LinearGradient(colors: [.purple.opacity(0.3), .pink.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: 40, height: 40)
                    .shadow(color: isHighest ? .yellow.opacity(0.5) : .purple.opacity(0.3), radius: 8)
                
                Text("\(rank)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(isHighest ? .black : .white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Score: \(score.number)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    if isHighest {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    // Performance indicator
                    HStack(spacing: 4) {
                        Image(systemName: getPerformanceIcon(score: score.number))
                            .foregroundColor(getPerformanceColor(score: score.number))
                            .font(.caption)
                        
                        Text(getPerformanceText(score: score.number))
                            .font(.caption2)
                            .foregroundColor(getPerformanceColor(score: score.number))
                    }
                }
                
                Text(score.TestDate.displayDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Progress bar
                ProgressView(value: Double(score.number), total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: getPerformanceColor(score: score.number)))
                    .scaleEffect(y: 2)
            }
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isHighest ?
                            LinearGradient(colors: [.yellow.opacity(0.5), .orange.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing) :
                            LinearGradient(colors: [.purple.opacity(0.3), .pink.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing),
                            lineWidth: 1
                        )
                }
        }
        .shadow(
            color: isHighest ? .yellow.opacity(0.2) : .purple.opacity(0.1),
            radius: isPressed ? 2 : 8,
            y: isPressed ? 1 : 4
        )
        .scaleEffect(isPressed ? 0.98 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPressed)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isPressed = false
                }
            }
        }
    }
    
    private func getPerformanceIcon(score: Int) -> String {
        switch score {
        case 40...180: return "flame.fill"
        case 30...40: return "bolt.fill"
        case 20...30: return "checkmark.circle.fill"
        default: return "arrow.up.circle.fill"
        }
    }
    
    private func getPerformanceColor(score: Int) -> Color {
        switch score {
        case 60...180: return .green
        case 45..<60: return .blue
        case 30..<45: return .orange
        case 20..<30: return .yellow
        default: return .red
        }
    }
    
    private func getPerformanceText(score: Int) -> String {
        switch score {
        case 60...180: return "Excellent!"
        case 45..<60: return "Great!"
        case 20..<45: return "Good"
        case 10..<20: return "Fair"
        default: return "Keep Trying!"
        }
    }
}

