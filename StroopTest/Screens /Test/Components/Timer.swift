//
//  Timer.swift
//  StroopTest
//
//  Created by Hari's Mac on 27.05.2025.
//

import SwiftUI

struct Timer: View {
    @State private var timeRemaining: Int = 30
    @State private var isRunning = false
    @State private var timerTask: Task<(), Never>? = nil
    @Binding var isFinished:Bool
    @State private var showAlert  = false
    @Binding var score: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Text(formattedTime(timeRemaining))
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundColor(timerColor)
                .animation(.easeInOut(duration: 0.3), value: timeRemaining)
            if isFinished {
                Text("Time's Up!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .scaleEffect(1.2)
                    .animation(.bouncy, value: isFinished)
            }
        }
        .onAppear{
            startTimer()
        }
        .padding()
        .onDisappear {
            stopTimer()
        }
        .alert("⏰ Time's Up!", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Score : \(score)")
        }
    }
    
    // MARK: - Computed Properties
    private var canReset: Bool {
        !isRunning && (timeRemaining < 30 || isFinished)
    }
    
    private var timerColor: Color {
        if isFinished {
            return .red
        } else if timeRemaining <= 10 {
            return .orange
        } else if timeRemaining <= 20 {
            return .yellow
        } else {
            return isRunning ? .white : .gray
        }
    }
    
    // MARK: - Timer Control Methods
    private func startTimer() {
        guard !isRunning && !isFinished else { return }
        
        isRunning = true
        timerTask = Task {
            while !Task.isCancelled && isRunning && timeRemaining > 0 {
                do {
                    try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                    if !Task.isCancelled && isRunning {
                        await MainActor.run {
                            timeRemaining -= 1
                            if timeRemaining <= 0 {
                                timeRemaining = 0
                                isRunning = false
                                isFinished = true
                                showAlert = true
                                // Optional: Add haptic feedback or sound
                                let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
                                impactFeedback.impactOccurred()
                            }
                        }
                    }
                } catch {
                    // Task was cancelled, break the loop
                    break
                }
            }
        }
    }
    
    private func stopTimer() {
        isRunning = false
        timerTask?.cancel()
        timerTask = nil
    }
    
    private func resetTimer() {
        stopTimer()
        timeRemaining = 45
        isFinished = false
    }
    
    // MARK: - Helper Methods
    func formattedTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
}

#Preview {
    Timer(isFinished: .constant(false), score: .constant(0))
}
