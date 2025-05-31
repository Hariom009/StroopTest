import SwiftUI
import UIKit


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
    @State private var showStartTest = false
    @State private var AlertForRetake = false
    @State private var showHomeView = false
    @State private var countDownTimer = 14
    // NEW: share-sheet state
    @State private var showShareSheet = false
    @State private var reportImage: UIImage?
    
    // Computed property for wrong answers
    private var wrongAnswers: Int {
        totalQuestions - correctAnswers
    }
    
    var body: some View {
        ZStack {
            // Animated background gradient
            LiveBackgroundView(backgroundGradientOpacity: $backgroundGradientOpacity, particleAnimation: $particleAnimation)
            
            ScrollView {
                VStack(spacing: 35) {
                    // Celebration emoji with bounce effect
                    GlowingEmojiView(text: "🎉", celebrationScale: $celebrationScale, glowEffect: $glowEffect)
                    
                    // Title with typewriter effect
                    GradientTextView(text: "Stroop Test Complete!", titleOpacity: $titleOpacity)
                    
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
                    
                    HStack(spacing: 70){
                        Button(action: {
                            // Take Report in this button...
                        }) {
                            Label("Share Report", systemImage: "square.and.arrow.up")
                                .font(.system(size: 10))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(
                                            LinearGradient(
                                                colors: [.black],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                )
                                .foregroundColor(.white)
                        }
                        Button{
                            AlertForRetake = true
                        }label:{
                            ButtonLablegradient(buttonName: "Retake test", systemimage: "repeat")
                        }
                    }
                    .padding()
                    .opacity(scoreOpacity)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
            }
            .scrollIndicators(.hidden)
            .overlay {
                if AlertForRetake {
                    CountdownAlertView(
                        isPresented: $AlertForRetake,
                        showStartTest: $showStartTest,
                        countDownTimer: $countDownTimer
                    )
                }
            }
        }
        .onChange(of: showStartTest) { newValue,_ in
            if newValue {
                // Navigate to start test screen or whatever action you need
                showHomeView = true
                showStartTest = false // Reset the state
            }
        }
        .onAppear {
            startAnimationSequence()
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        .fullScreenCover(isPresented: $showHomeView){
           UpgradedStartView()
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
        case 60...180: return "Excellent!"
        case 45..<60: return "Great!"
        case 20..<45: return "Good"
        case 10..<20: return "Fair"
        default: return "Keep Trying!"
        }
    }
    
    private func getPerformanceColor() -> Color {
        switch score {
        case 60...180: return .green
        case 45..<60: return .blue
        case 30..<45: return .orange
        case 20..<30: return .yellow
        default: return .red
        }
    }
    
    private func getPerformanceDescription() -> String {
        switch score {
        case 60...180: return "Outstanding performance! Excellent cognitive flexibility."
        case 45..<60: return "Well done! Good attention control."
        case 30..<45: return "Nice work! Room for improvement."
        case 20..<30: return "Keep control over your screen time."
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
