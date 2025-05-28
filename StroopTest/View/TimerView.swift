import SwiftUI

struct AsyncTimerView: View {
    @State private var timeRemaining: Int = 45 // Start with 45 seconds
    @State private var isRunning = false
    @State private var timerTask: Task<(), Never>? = nil
    @State private var isFinished = false
    
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
    }
    
    // MARK: - Computed Properties
    private var canReset: Bool {
        !isRunning && (timeRemaining < 45 || isFinished)
    }
    
    private var timerColor: Color {
        if isFinished {
            return .red
        } else if timeRemaining <= 10 {
            return .orange
        } else if timeRemaining <= 20 {
            return .yellow
        } else {
            return isRunning ? .primary : .secondary
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

// MARK: - Alternative Implementation with more precise timing
struct PreciseAsyncTimerView: View {
    @State private var elapsed: TimeInterval = 0
    @State private var isRunning = false
    @State private var timerTask: Task<(), Never>? = nil
    @State private var startTime: Date?
    @State private var pausedDuration: TimeInterval = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Text(formattedTime(elapsed))
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundColor(isRunning ? .primary : .secondary)
            
            HStack(spacing: 30) {
                Button(isRunning ? "Pause" : "Start") {
                    if isRunning {
                        pauseTimer()
                    } else {
                        startTimer()
                    }
                }
                .foregroundColor(isRunning ? .orange : .green)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isRunning ? Color.orange.opacity(0.2) : Color.green.opacity(0.2))
                )
                
                Button("Reset") {
                    resetTimer()
                }
                .disabled(!canReset)
                .foregroundColor(canReset ? .red : .gray)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(canReset ? Color.red.opacity(0.2) : Color.gray.opacity(0.1))
                )
            }
            .font(.title2)
            .fontWeight(.semibold)
            
            // Display milliseconds for precision
            Text(String(format: "%.1f seconds", elapsed))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .onDisappear {
            stopTimer()
        }
    }
    
    // MARK: - Computed Properties
    private var canReset: Bool {
        !isRunning && elapsed > 0
    }
    
    // MARK: - Timer Control Methods
    private func startTimer() {
        guard !isRunning else { return }
        
        isRunning = true
        startTime = Date()
        
        timerTask = Task {
            while !Task.isCancelled && isRunning {
                do {
                    try await Task.sleep(nanoseconds: 16_666_667) // ~60 FPS updates
                    if !Task.isCancelled && isRunning {
                        await MainActor.run {
                            updateElapsedTime()
                        }
                    }
                } catch {
                    break
                }
            }
        }
    }
    
    private func pauseTimer() {
        guard isRunning else { return }
        
        isRunning = false
        timerTask?.cancel()
        timerTask = nil
        
        if let start = startTime {
            pausedDuration += Date().timeIntervalSince(start)
        }
    }
    
    private func stopTimer() {
        isRunning = false
        timerTask?.cancel()
        timerTask = nil
    }
    
    private func resetTimer() {
        stopTimer()
        elapsed = 0
        pausedDuration = 0
        startTime = nil
    }
    
    private func updateElapsedTime() {
        guard let start = startTime else { return }
        elapsed = pausedDuration + Date().timeIntervalSince(start)
    }
    
    // MARK: - Helper Methods
    func formattedTime(_ timeInterval: TimeInterval) -> String {
        let totalSeconds = Int(timeInterval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

#Preview("Basic Timer") {
    AsyncTimerView()
}

#Preview("Precise Timer") {
    PreciseAsyncTimerView()
}
