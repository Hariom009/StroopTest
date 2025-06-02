import SwiftUI
import SwiftUISpeechToText
import CoreHaptics

struct UpdatedQA: View {
    // Your source data
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var TestCoolDown: TestCooldownManager
    let colourNames = ["Red","Blue","Yellow","Green","Purple","Orange","Pink","Maroon","White","Grey","Violet","SkyBlue", "Cyan", "Beige","Brown"]
    let colours: [String: Color] = [
        "red": .red,    "blue": .blue,"yellow": .yellow,
        "green": .green,"purple": .purple,"orange": .orange,
        "pink": .pink,  "maroon": Color(red: 0.5, green: 0.0, blue: 0.0), "white": .white,
        "grey": .gray,  "violet": Color(red: 0.56, green: 0.0, blue: 1.0), "skyblue": .cyan,
        "cyan": .cyan,"read" :.red
    ]
    @State var totalQuestion : Int = 0
    @State var correctQuestion : Int = 0
    @State private var displayedWord = ""
    @State private var displayedInkName = ""
    @State private var recordedResponse = ""
    @State private var score = 0
    @State private var timer = 45.0
    @State private var isFinished = false
    @State private var isRecording = true
    @State private var isProcessingAnswer = false
    @State private var showEvaluation = false
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State  var NotificationfeedbackGenerator = UINotificationFeedbackGenerator()
    
    // New timer for auto-advance
    @State private var questionTask: Task<Void, Never>?
    
    @GestureState private var dragOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                if !isFinished{
                HStack{
                    Timer(isFinished: $isFinished,score: $score)
                        Spacer()
                    }
                }else {
                 EvaluationView(Score: $score,totalQuestion: $totalQuestion, correctQuestion: $correctQuestion)
                }
                if !isFinished {
                    // Stroop stimulus card
                    Text(displayedWord)
                        .font(.system(size: 70, weight: .bold, design: .rounded))
                        .foregroundColor(colours[displayedInkName] ?? .white)
                        .padding(40)
                    // Move with your finger
                        .offset(x: dragOffset.width, y: 0)
                        .animation(.spring(), value: dragOffset)
                    
                    Spacer()
                }
                if !isFinished{
                    VStack(spacing: 20) {
                        // Animated microphone
                        Text("Speak the colour")
                            .foregroundStyle(.secondary)
                        AnimatedMicView(
                            isListening: .constant(isRecording && !isFinished),
                            micSize: 80,
                            waveColor: .blue,
                            micColor: .white
                        )
                    }
                    .padding(.bottom, 50)
                }
            }
            .padding()
            .gesture(
                DragGesture(minimumDistance: 40, coordinateSpace: .local)
                    .updating($dragOffset) { value, state, _ in
                        // only allow leftward drag
                        if value.translation.width < 0 {
                            state = value.translation
                        }
                    }
                    .onEnded { value in
                        guard value.translation.width < -80 else { return }
                        guard !speechRecognizer.transcript.isEmpty else { return }
                        
                        // Haptic flourish
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        
                        // Animate submission + reset
                        withAnimation(.easeInOut(duration: 0.4)) {
                            processAnswer()
                        }
                    }
            )
            // Monitor speech transcript for color names
            .onChange(of: speechRecognizer.transcript) { _, newTranscript in
                checkForColorName(in: newTranscript)
            }
            // Handle timer finish - stop recording
            .onChange(of: isFinished) { _, finished in
                if finished && isRecording {
                    isRecording = false
                    speechRecognizer.stopTranscribing()
                    stopQuestionTimer()
                }
            }
        }
        .onAppear {
            loadNewQuestion()
            TestCoolDown.startNewCooldown()
        }
        .onDisappear {
            stopQuestionTimer()
        }
    }
    
    // MARK: — Start question timer
    private func startQuestionTimer() {
        stopQuestionTimer() // Stop any existing task
        
        questionTask = Task {
            try? await Task.sleep(nanoseconds: 1_800_000_000) // 1.8 seconds
            if !Task.isCancelled && !isFinished && !isProcessingAnswer {
                await MainActor.run {
                    loadNewQuestion()
                }
            }
        }
    }
    
    // MARK: — Stop question timer
    private func stopQuestionTimer() {
        questionTask?.cancel()
        questionTask = nil
    }
    
    // MARK: — Check if spoken text contains a color name
    private func checkForColorName(in transcript: String) {
        guard isRecording && !isProcessingAnswer && !isFinished else { return }
        
        let cleanTranscript = transcript.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // Check if any color name is mentioned in the transcript
        let allColorNames = Array(colours.keys).map { $0.lowercased() } + colourNames.map { $0.lowercased() }
        
        for colorName in allColorNames {
            if cleanTranscript.contains(colorName) {
                recordedResponse = colorName
                processAnswer()
                NotificationfeedbackGenerator.notificationOccurred(.success)
                break
            }
        }
    }
    
    // MARK: — Load a fresh Stroop prompt
    private func loadNewQuestion() {
        guard !isFinished else { return }
        
        displayedWord = colourNames.randomElement()!
        displayedInkName = colours.keys.randomElement()!
        recordedResponse = ""
        isProcessingAnswer = false
        totalQuestion += 1
        
        
        // Start recording for new question
        isRecording = true
        if isRecording {
            speechRecognizer.transcribe()
        }
        
        // Start the 1.5 second timer for auto-advance
        startQuestionTimer()
    }
    
    // MARK: — Process the answer and move to next question
    private func processAnswer() {
        guard !isProcessingAnswer && !isFinished else { return }
        isProcessingAnswer = true
        isRecording = false
        
        // Stop the question timer since user responded
        stopQuestionTimer()
        
        // Stop speech recognition
        speechRecognizer.stopTranscribing()
        
        // Score the answer
        submitAnswer()
        
        // Add a small delay before loading next question for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if !isFinished {
                loadNewQuestion()
            }
        }
    }
    
    // MARK: — Score your response
    private func submitAnswer() {
        let response = recordedResponse
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        if response == displayedInkName.lowercased() {
            score += 5
            correctQuestion += 1
            NotificationfeedbackGenerator.notificationOccurred(.success)
        }else {
            NotificationfeedbackGenerator.notificationOccurred(.error)
        }
    }
}

#Preview {
    UpdatedQA(TestCoolDown: TestCooldownManager())
}
