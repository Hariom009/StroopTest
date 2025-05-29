
import SwiftUI

struct AnimatedMicView: View {
    @Binding var isListening: Bool
    @State private var pulseScale: CGFloat = 1.0
    @State private var waveScale1: CGFloat = 0.8
    @State private var waveScale2: CGFloat = 0.6
    @State private var waveScale3: CGFloat = 0.4
    @State private var waveOpacity1: Double = 0.8
    @State private var waveOpacity2: Double = 0.6
    @State private var waveOpacity3: Double = 0.4
    @State private var rotationAngle: Double = 0
    
    let micSize: CGFloat
    let waveColor: Color
    let micColor: Color
    
    init(isListening: Binding<Bool>,
         micSize: CGFloat = 60,
         waveColor: Color = .blue,
         micColor: Color = .white) {
        self._isListening = isListening
        self.micSize = micSize
        self.waveColor = waveColor
        self.micColor = micColor
    }
    
    var body: some View {
        ZStack {
            // Outer wave rings (only show when listening)
            if isListening {
                // Wave ring 3 (outermost)
                Circle()
                    .stroke(waveColor.opacity(waveOpacity3), lineWidth: 2)
                    .scaleEffect(waveScale3)
                    .opacity(waveOpacity3)
                
                // Wave ring 2 (middle)
                Circle()
                    .stroke(waveColor.opacity(waveOpacity2), lineWidth: 2)
                    .scaleEffect(waveScale2)
                    .opacity(waveOpacity2)
                
                // Wave ring 1 (innermost)
                Circle()
                    .stroke(waveColor.opacity(waveOpacity1), lineWidth: 3)
                    .scaleEffect(waveScale1)
                    .opacity(waveOpacity1)
            }
            
            // Main microphone container
            Circle()
                .fill(waveColor.opacity(isListening ? 0.2 : 0.1))
                .frame(width: micSize, height: micSize)
                .scaleEffect(pulseScale)
                .overlay {
                    Circle()
                        .stroke(waveColor.opacity(isListening ? 0.5 : 0.3), lineWidth: 2)
                }
            
            // Microphone icon
            Image(systemName: "mic.fill")
                .font(.system(size: micSize * 0.35, weight: .medium))
                .foregroundColor(micColor)
                .rotationEffect(.degrees(rotationAngle))
                .scaleEffect(isListening ? 1.1 : 1.0)
        }
        .frame(width: micSize * 2, height: micSize * 2)
        .onChange(of: isListening) { _, listening in
            if listening {
                startListeningAnimation()
            } else {
                stopListeningAnimation()
            }
        }
        .onAppear {
            if isListening {
                startListeningAnimation()
            }
        }
    }
    
    private func startListeningAnimation() {
        // Pulse animation for main circle
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.05
        }
        
        // Wave animations with different timings
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
            waveScale1 = 1.4
            waveOpacity1 = 0.0
        }
        
        withAnimation(.easeInOut(duration: 2.0).delay(0.3).repeatForever(autoreverses: false)) {
            waveScale2 = 1.8
            waveOpacity2 = 0.0
        }
        
        withAnimation(.easeInOut(duration: 2.5).delay(0.6).repeatForever(autoreverses: false)) {
            waveScale3 = 2.2
            waveOpacity3 = 0.0
        }
        
//        // Subtle rotation for the mic icon
//        withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
//            rotationAngle = 360
//        }
    }
    
    private func stopListeningAnimation() {
        // Stop all animations and return to calm state
        withAnimation(.easeOut(duration: 0.5)) {
            pulseScale = 1.0
            waveScale1 = 0.8
            waveScale2 = 0.6
            waveScale3 = 0.4
            waveOpacity1 = 0.8
            waveOpacity2 = 0.6
            waveOpacity3 = 0.4
            rotationAngle = 0
        }
    }
}

// MARK: - Preview
struct AnimatedMicView_Previews: PreviewProvider {
    @State static var isListening = true
    
    static var previews: some View {
        VStack(spacing: 50) {
            // Listening state
            VStack {
                Text("Listening")
                    .font(.headline)
                AnimatedMicView(isListening: .constant(true))
            }
            
            // Calm state
            VStack {
                Text("Calm")
                    .font(.headline)
                AnimatedMicView(isListening: .constant(false))
            }
            
            // Interactive toggle
            VStack {
                Text("Interactive")
                    .font(.headline)
                AnimatedMicView(isListening: $isListening)
                
                Button("Toggle Listening") {
                    isListening.toggle()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.black)
    }
}
