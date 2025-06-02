//
//  TestHistory.swift
//  StroopTest
//
//  Created by Hari's Mac on 01.06.2025.
import SwiftUI
import SwiftData
import Charts

struct TestHistory: View {
    @Query var Scores: [Score]
    @State private var animateChart = false
    @State private var animateCards = false
    @State private var selectedScore: Score?
    
    var sortedScores: [Score] {
        Scores.sorted { $0.TestDate < $1.TestDate }
    }
    
    var body: some View {
        ZStack {
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
                // Animated particles
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
            
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Header with glow effect
                    VStack(spacing: 8) {
                        Text("Performance Analytics")
                            .font(.largeTitle)
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
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .opacity(animateChart ? 1 : 0)
                            .animation(.easeInOut(duration: 1).delay(0.5), value: animateChart)
                    }
                    .padding(.top, 20)
                    
                    // Chart Section
                    if !sortedScores.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Score Trends")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                // Stats summary
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("Best: \(sortedScores.map(\.number).max() ?? 0)")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                    Text("Latest: \(sortedScores.last?.number ?? 0)")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            // Chart with glassmorphism effect
                            Chart(sortedScores) { score in
                                LineMark(
                                    x: .value("Date", score.TestDate),
                                    y: .value("Score", score.number)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.purple, .pink],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                                .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round))
                                
                                AreaMark(
                                    x: .value("Date", score.TestDate),
                                    y: .value("Score", score.number)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.purple.opacity(0.3), .clear],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                
                                PointMark(
                                    x: .value("Date", score.TestDate),
                                    y: .value("Score", score.number)
                                )
                                .foregroundStyle(.white)
                                .symbolSize(60)
                            }
                            .frame(height: 200)
                            .chartBackground { chartProxy in
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                                    .environment(\.colorScheme, .dark)
                            }
                            .scaleEffect(animateChart ? 1 : 0.8)
                            .opacity(animateChart ? 1 : 0)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3), value: animateChart)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .environment(\.colorScheme, .dark)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.purple.opacity(0.5), .pink.opacity(0.3)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                }
                        }
                        .shadow(color: .purple.opacity(0.2), radius: 20)
                        .padding(.horizontal, 16)
                    }
                    
                    // Test History Cards
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Test History")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(Scores.count) tests")
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.ultraThinMaterial)
                                .environment(\.colorScheme, .dark)
                                .clipShape(Capsule())
                        }
                        .padding(.horizontal, 20)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(Array(sortedScores.reversed().enumerated()), id: \.element) { index, score in
                                TestHistoryCard(
                                    score: score,
                                    rank: index + 1,
                                    isHighest: score.number == sortedScores.map(\.number).max(),
                                    animationDelay: Double(index) * 0.1
                                )
                                .opacity(animateCards ? 1 : 0)
                                .offset(y: animateCards ? 0 : 50)
                                .animation(
                                    .spring(response: 0.6, dampingFraction: 0.8)
                                    .delay(Double(index) * 0.1 + 0.8),
                                    value: animateCards
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        selectedScore = selectedScore == score ? nil : score
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Test History")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animateChart = true
            }
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                animateCards = true
            }
        }
    }
}

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
        case 80...100: return "flame.fill"
        case 60...79: return "bolt.fill"
        case 40...59: return "checkmark.circle.fill"
        default: return "arrow.up.circle.fill"
        }
    }
    
    private func getPerformanceColor(score: Int) -> Color {
        switch score {
        case 80...100: return .red
        case 60...79: return .orange
        case 40...59: return .yellow
        default: return .blue
        }
    }
    
    private func getPerformanceText(score: Int) -> String {
        switch score {
        case 80...100: return "Excellent"
        case 60...79: return "Good"
        case 40...59: return "Average"
        default: return "Keep Going"
        }
    }
}

extension Date {
    var displayDate: String {
        self.formatted(.dateTime.day().month(.wide).year())
    }
}

#Preview {
    let modelContainer = try! ModelContainer(for: Score.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = modelContainer.mainContext
    
    // Add sample data for better preview
    context.insert(Score(number: 85, TestDate: Calendar.current.date(byAdding: .day, value: -7, to: Date.now)!))
    context.insert(Score(number: 72, TestDate: Calendar.current.date(byAdding: .day, value: -5, to: Date.now)!))
    context.insert(Score(number: 91, TestDate: Calendar.current.date(byAdding: .day, value: -3, to: Date.now)!))
    context.insert(Score(number: 68, TestDate: Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!))
    context.insert(Score(number: 79, TestDate: Date.now))
    
    return NavigationView {
        TestHistory()
            .modelContainer(modelContainer)
            .preferredColorScheme(.dark)
    }
}
