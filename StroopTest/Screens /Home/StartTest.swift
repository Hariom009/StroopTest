//
//  StartText.swift
//  StroopTest
//
//  Created by Hari's Mac on 28.05.2025.
//

import SwiftUI

struct StartTest: View {
    let stroopviewColor = Color(red: 30.0 / 255.0, green: 0.0 / 255.0, blue: 36.0 / 255.0)
    @State private var showTest = false
    @State private var countdown: Int? = nil
    
    var body: some View {
        ZStack {
            stroopviewColor.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header - Keep as requested
                HStack {
                    Text("Attention Test")
                        .font(.system(size: 25, weight: .heavy))
                        .foregroundColor(.white)
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Image - Keep as requested
                        Image("lvl4")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                        
                        // What is Stroop Test
                        InfoCard(
                            title: "🧠 What is the Stroop Test?",
                            content: "A psychological task that measures attention and cognitive flexibility. Identify the color of words, not what they spell - even when they conflict!"
                        )
                        
                        // How to take the test
                        InfoCard(
                            title: "📝 How to Take the Test",
                            content: """
                            • See color words (Red, Blue, Green)
                            • Select the text color, not the word
                            • Example: "Green" in red = answer "Red"
                            • Stay focused and respond quickly
                            """
                        )
                        
                        // Benefits
                        InfoCard(
                            title: "✨ Why Take This Test?",
                            content: """
                            • Measures cognitive control
                            • Tests mental flexibility
                            • Screens attention issues
                            • Fun and engaging challenge
                            """
                        )
                        
                        // Answer method
                        InfoCard(
                            title: "🎙️ How to Answer",
                            content: "Use the mic button to record your voice answer, then tap next to continue."
                        )
                    }
                    .padding(.horizontal)
                }
                .scrollIndicators(.hidden)
                
                // Start Button
                Button {
                    startCountdown()
                } label: {
                    Text("Start Test")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.black)
                        )
                }
                .padding()
            }
            
            // Countdown Overlay
            if let count = countdown {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                Text("\(count)")
                    .font(.system(size: 120, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: countdown)
//        .fullScreenCover(isPresented: $showTest) {
//            QA(TestCoolDown: )
//        }
    }
    
    private func startCountdown() {
        countdown = 3
        
        Task {
            while let current = countdown, current > 0 {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                countdown! -= 1
            }
            try? await Task.sleep(nanoseconds: 300_000_000)
            countdown = nil
            showTest = true
        }
    }
}



#Preview {
    StartTest()
}
