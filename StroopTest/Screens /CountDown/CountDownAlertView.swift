import SwiftUI
import Combine

struct CountdownAlertView: View {
    @Binding var isPresented: Bool
    @State private var timeRemaining: TimeInterval = 0
    @State private var isRunning: Bool = false
    @State private var timerTask: Task<Void, Never>? = nil
    @Binding var showStartTest: Bool
    @Binding var countDownTimer: Int
    
    init(isPresented: Binding<Bool>, showStartTest: Binding<Bool>, countDownTimer: Binding<Int>) {
        self._isPresented = isPresented
        self._showStartTest = showStartTest
        self._countDownTimer = countDownTimer
    }
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            // Alert content
            VStack(spacing: 20) {
                Text("Buy Premium")
                    .font(.headline)
                    .fontWeight(.bold)
                
                VStack(spacing: 10) {
                    Text("In free version you can attempt this test once every 14 days")
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                    
                    if timeRemaining > 0 {
                        Text(formatTimeRemaining())
                            .font(.system(.caption, design: .monospaced))
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .padding(.vertical, 8)
                    } else {
                        Text("You can attempt the test for free now")
                            .font(.system(.title3))
                            .fontWeight(.semibold)
                            .foregroundColor(.green)
                            .padding(.vertical, 8)
                    }
                }
                
                HStack(spacing: 15) {
                    if timeRemaining <= 0 {
                        Button("Start Test") {
                            showStartTest = true
                            isPresented = false
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    Button("Dismiss") {
                        isPresented = false
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.systemBackground))
            )
            .shadow(radius: 8)
            .padding(30)
        }
        .onAppear {
            updateTimeRemaining()
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func updateTimeRemaining() {
        timeRemaining = TestCooldownManager.shared.getRemainingTime()
    }
    
    private func startTimer() {
        guard !isRunning else { return }
        
        isRunning = true
        timerTask = Task {
            while !Task.isCancelled && isRunning {
                do {
                    try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                    if !Task.isCancelled && isRunning {
                        await MainActor.run {
                            // Always recalculate from stored end date to ensure accuracy
                            timeRemaining = TestCooldownManager.shared.getRemainingTime()
                            
                            if timeRemaining <= 0 {
                                timeRemaining = 0
                                showStartTest = true
                            }
                        }
                    }
                } catch {
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
    
    private func formatTimeRemaining() -> String {
        let days = Int(timeRemaining) / (24 * 3600)
        let hours = (Int(timeRemaining) % (24 * 3600)) / 3600
        let minutes = (Int(timeRemaining) % 3600) / 60
        let seconds = Int(timeRemaining) % 60
        
        return "\(days) days \(hours) hr \(minutes) min \(seconds) sec"
    }
}

