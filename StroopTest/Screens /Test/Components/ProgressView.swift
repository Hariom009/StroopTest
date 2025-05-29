import SwiftUI
import Foundation
// Updated progress view that accepts a binding and completion callback
struct ReliableAnimatedCircularProgressView: View {
    @Binding var progress: Double
    let onCompletion: () -> Void
    @State private var timer: DispatchSourceTimer?
    @State private var isAnimating = false
    
    init(progress: Binding<Double>, onCompletion: @escaping () -> Void = {}) {
        self._progress = progress
        self.onCompletion = onCompletion
    }
    
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                // Background circle
                Circle()
                    .stroke(
                        Color.gray.opacity(0.3),
                        lineWidth: 20
                    )
                
                // Progress circle
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: 20,
                            lineCap: .round
                        )
                    )
                    .foregroundColor(.blue)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.2), value: progress)
                
                // Percentage text in center
                Text("\(Int(progress * 99))%")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(width: 200, height: 200)
        }
        .padding()
        .onAppear {
            startProgressAnimation()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startProgressAnimation() {
        guard !isAnimating else { return }
        
        // Stop any existing timer
        stopTimer()
        
        // Reset progress
        progress = 0.01
        isAnimating = true
        
        // Create dispatch timer
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer?.schedule(deadline: .now(), repeating: .milliseconds(50))
        
        timer?.setEventHandler { [self] in
            if progress < 1.0 {
                progress += 0.01
            } else {
                stopTimer()
                onCompletion() // Call completion when done
            }
        }
        
        timer?.resume()
    }
    
    private func stopTimer() {
        timer?.cancel()
        timer = nil
        isAnimating = false
    }
}

#Preview {
    ReliableAnimatedCircularProgressView(progress: .constant(1))
        .preferredColorScheme(.dark)
}
