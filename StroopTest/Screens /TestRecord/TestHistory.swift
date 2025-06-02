import SwiftUI
import SwiftData
import Charts

struct TestHistory: View {
    @Query var allScores: [Score]
    @State private var animateChart = false
    @State private var animateCards = false
    @State private var selectedScore: Score?
    @State private var selectedTestType: String = "Attention Test"
    
    // Since Score model doesn't have testType, we'll treat all existing scores as Attention Test scores
    var filteredScores: [Score] {
        if selectedTestType == "Attention Test" {
            return allScores.sorted { $0.TestDate < $1.TestDate }
        } else {
            return [] // Other tests have no data yet
        }
    }
    
    var body: some View {
        ZStack {
            TestHistoryBG(animateChart: $animateChart)
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Heading
                    TestHistoryHeader(animateChart: $animateChart)
                    
                    // Test Selector
                    TestSelectorForAnalytics(selectedTestType: $selectedTestType)
                    
                    // Show content based on selected test and data availability
                    if selectedTestType == "Attention Test" {
                        if !filteredScores.isEmpty {
                            chartSection
                            testHistoryCards
                        } else {
                            emptyStateView
                        }
                    } else {
                        comingSoonView
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
        .onChange(of: selectedTestType) { _, _ in
            // Reset animations when test type changes
            withAnimation(.easeInOut(duration: 0.5)) {
                animateChart = false
                animateCards = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    animateChart = true
                }
                withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                    animateCards = true
                }
            }
        }
    }
    
    // MARK: - Chart Section
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Score Trends")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                // Stats summary
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Best: \(filteredScores.map(\.number).max() ?? 0)")
                        .font(.caption)
                        .foregroundColor(.green)
                    Text("Latest: \(filteredScores.last?.number ?? 0)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            // Chart with glassmorphism effect
            Chart(filteredScores) { score in
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
    
    // MARK: - Test History Cards
    private var testHistoryCards: some View {
        VStack(alignment: .leading, spacing: 16) {
            Subheading(Scores: filteredScores)
                .padding(.horizontal, 20)
            
            LazyVStack(spacing: 12) {
                ForEach(Array(filteredScores.reversed().enumerated()), id: \.element) { index, score in
                    TestHistoryCard(
                        score: score,
                        rank: index + 1,
                        isHighest: score.number == filteredScores.map(\.number).max(),
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
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 60))
                .foregroundColor(.purple.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No Test History")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Take your first \(selectedTestType.lowercased()) to see your progress here")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 60)
        .opacity(animateChart ? 1 : 0)
        .animation(.easeInOut(duration: 0.8).delay(0.3), value: animateChart)
    }
    
    // MARK: - Coming Soon View
    private var comingSoonView: some View {
        VStack(spacing: 24) {
            Image(systemName: "clock.badge.questionmark")
                .font(.system(size: 60))
                .foregroundColor(.orange.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("Coming Soon")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("\(selectedTestType) history will be available in future updates")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 60)
        .opacity(animateChart ? 1 : 0)
        .animation(.easeInOut(duration: 0.8).delay(0.3), value: animateChart)
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
    
    // Add sample data for better preview - using existing Score model
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
