import SwiftUI

struct ScoreView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var score: Int
    @Binding var totalQuestions: Int
    @Binding var correctAnswers: Int
    
    @State private var celebrationScale: CGFloat = 0.1
    @State private var titleOpacity: Double = 0
    @State private var scoreScale: CGFloat = 0.5
    @State private var scoreOpacity: Double = 0
    @State private var animatedScore: Int = 0
    @State private var animatedCorrect: Int = 0
    @State private var animatedWrong: Int = 0
    @State private var reportOpacity: Double = 0
    @State private var reportScale: CGFloat = 0.8
    @State private var buttonOffset: CGFloat = 50
    @State private var buttonOpacity: Double = 0
    @State private var backgroundGradientOpacity: Double = 0
    @State private var particleAnimation = false
    @State private var glowEffect = false
    
    // Computed property for wrong answers
    private var wrongAnswers: Int {
        totalQuestions - correctAnswers
    }
    
    var body: some View {
        ZStack {
            // Animated background gradient
            LinearGradient(
                colors: [
                    Color.purple.opacity(0.1),
                    Color.blue.opacity(0.1),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(backgroundGradientOpacity)
            .ignoresSafeArea()
            
            // Floating particles effect
            ForEach(0..<20, id: \.self) { index in
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: CGFloat.random(in: 2...6))
                    .position(
                        x: CGFloat.random(in: 50...350),
                        y: particleAnimation ? CGFloat.random(in: 100...700) : CGFloat.random(in: 200...600)
                    )
                    .opacity(particleAnimation ? 0.8 : 0.3)
                    .animation(
                        .linear(duration: Double.random(in: 3...6))
                        .repeatForever(autoreverses: true)
                        .delay(Double.random(in: 0...2)),
                        value: particleAnimation
                    )
            }
            
            ScrollView {
                VStack(spacing: 35) {
                    // Celebration emoji with bounce effect
                    Text("🎉")
                        .font(.system(size: 100))
                        .scaleEffect(celebrationScale)
                        .shadow(color: .yellow.opacity(0.8), radius: glowEffect ? 20 : 5)
                        .animation(
                            .spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.3),
                            value: celebrationScale
                        )
                        .animation(
                            .easeInOut(duration: 2)
                            .repeatForever(autoreverses: true),
                            value: glowEffect
                        )
                    
                    // Title with typewriter effect
                    VStack(spacing: 20) {
                        Text("Stroop Test Complete!")
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
                    
                    // Score display with counter animation
                    VStack(spacing: 15) {
                        Text("Your Score")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                            .opacity(scoreOpacity)
                        
                        // Score number with animated background
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.blue.opacity(0.3),
                                            Color.purple.opacity(0.3)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 140, height: 80)
                                .shadow(color: .blue.opacity(0.3), radius: 15)
                                .scaleEffect(scoreScale)
                            
                            VStack(spacing: 5) {
                                Text("\(score)")
                                    .font(.system(size: 36, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                        }
                        .opacity(scoreOpacity)
                        
                        // Performance indicator
                        VStack(spacing: 8) {
                            Text(getPerformanceText())
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(getPerformanceColor())
                            
                            Text(getPerformanceDescription())
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .opacity(scoreOpacity)
                    }
                   // Test Report Here...
                    TestReportView(reportOpacity: $reportOpacity, totalQuestions: $totalQuestions, animatedCorrect: $animatedCorrect, animatedWrong: $animatedWrong, reportScale: $reportScale)
                    .padding(.horizontal)
                    
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
            }
        }
        .onAppear {
            startAnimationSequence()
        }
    }
    
    private func startAnimationSequence() {
        // Background fade in
        withAnimation(.easeIn(duration: 0.5)) {
            backgroundGradientOpacity = 1.0
        }
        
        // Celebration emoji bounce
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
            celebrationScale = 1.0
        }
        
        // Start glow effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            glowEffect = true
        }
        
        // Title fade in
        withAnimation(.easeInOut(duration: 0.8).delay(0.6)) {
            titleOpacity = 1.0
        }
        
        // Score section animation
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.0)) {
            scoreScale = 1.0
            scoreOpacity = 1.0
        }
        
        // Animate score counter
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            animateScoreCounter()
        }
        
        // Report section animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(1.8)) {
            reportScale = 1.0
            reportOpacity = 1.0
        }
        
        // Animate report counters
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            animateReportCounters()
        }
        
        // Button slide up
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(3.0)) {
            buttonOffset = 0
            buttonOpacity = 1.0
        }
        
        // Start particle animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            particleAnimation = true
        }
    }
    private func animateScoreCounter() {
        let duration: Double = 1.5
        let steps = 60
        let increment = score / steps
        
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + (duration / Double(steps)) * Double(i)) {
                let currentScore = min(increment * i, score)
                withAnimation(.easeOut(duration: 0.1)) {
                    animatedScore = currentScore
                }
            }
        }
    }
    
    private func animateReportCounters() {
        let duration: Double = 1.0
        let steps = 30
        
        // Animate correct answers
        let correctIncrement = max(1, correctAnswers / steps)
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + (duration / Double(steps)) * Double(i)) {
                let current = min(correctIncrement * i, correctAnswers)
                withAnimation(.easeOut(duration: 0.1)) {
                    animatedCorrect = current
                }
            }
        }
        
        // Animate wrong answers with slight delay
        let wrongIncrement = max(1, wrongAnswers / steps)
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 + (duration / Double(steps)) * Double(i)) {
                let current = min(wrongIncrement * i, wrongAnswers)
                withAnimation(.easeOut(duration: 0.1)) {
                    animatedWrong = current
                }
            }
        }
    }
    
    private func getPerformanceText() -> String {
        switch score {
        case 90...100: return "Excellent!"
        case 80..<90: return "Great!"
        case 70..<80: return "Good"
        case 60..<70: return "Fair"
        default: return "Keep Trying!"
        }
    }
    
    private func getPerformanceColor() -> Color {
        switch score {
        case 90...100: return .green
        case 80..<90: return .blue
        case 70..<80: return .orange
        case 60..<70: return .yellow
        default: return .red
        }
    }
    
    private func getPerformanceDescription() -> String {
        switch score {
        case 90...100: return "Outstanding performance! Excellent cognitive flexibility."
        case 80..<90: return "Well done! Good attention control."
        case 70..<80: return "Nice work! Room for improvement."
        case 50..<70: return "Keep control over your screen time."
        default: return "Use ridan effieciently & keep control of social media!"
        }
    }
}


#Preview {
    ScoreView(
        score: .constant(65),
        totalQuestions: .constant(25),
        correctAnswers: .constant(21)
    )
    .preferredColorScheme(.dark)
}
