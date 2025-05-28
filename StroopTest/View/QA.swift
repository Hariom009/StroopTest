import SwiftUI
import SwiftUISpeechToText
import CoreHaptics

struct QA: View {
    // Your source data
    let colourNames = ["Red","Blue","Yellow","Green","Purple","Orange","Pink","Brown","White","Grey","Violet"]
    let colours: [String: Color] = [
        "red": .red,    "blue": .blue,   "yellow": .yellow,
        "green": .green,"purple": .purple,"orange": .orange,
        "pink": .pink,  "brown": .brown, "white": .white,
        "grey": .gray,  "violet": Color(red: 0.56, green: 0.0, blue: 1.0)
    ]
    @State private var displayedWord = ""
    @State private var displayedInkName = ""
    @State private var recordedResponse = ""
    @State private var score = 0
    @State private var timer = 45.0
    @State private var isFinished = false
    @State private var isRecording = false

    // Gesture tracking
    @GestureState private var dragOffset: CGSize = .zero

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 30) {
                HStack{
                   Timer(isFinished: $isFinished,score: $score)
                    if !isFinished{
                        Spacer()
                    }
                }
                if !isFinished {
                    // Stroop stimulus card
                    Text(displayedWord)
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(colours[displayedInkName] ?? .white)
                        .padding(40)
                    // Move with your finger
                        .offset(x: dragOffset.width, y: 0)
                        .animation(.spring(), value: dragOffset)
                    
                    Spacer()
                    
                    // Speech-to-text field
                    MicView(isRecording: $isRecording, searchText: $recordedResponse)
                    
                        .padding(.horizontal)
                }

            }
            .padding()
            // Attach the drag gesture here
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
                        guard !recordedResponse.isEmpty else { return }

                        // Haptic flourish
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()

                        // Animate submission + reset
                        withAnimation(.easeInOut(duration: 0.4)) {
                            submitAnswer()
                            loadNewQuestion()
                        }
                    }
            )
            // Here when recording getting false and timer is running i switch to next question 
            .onChange(of: isRecording){ recording,_ in
                if !isRecording && !isFinished{
                    submitAnswer()
                    loadNewQuestion()
                }
            }
        }
        .onAppear {
            loadNewQuestion()
        }
    }

    // MARK: — Load a fresh Stroop prompt
    private func loadNewQuestion() {
        displayedWord = colourNames.randomElement()!
        displayedInkName = colours.keys.randomElement()!
        recordedResponse = ""
        isRecording.toggle()
    }

    // MARK: — Score your poetic response
    private func submitAnswer() {
        let response = recordedResponse
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        if response == displayedInkName.lowercased() {
            score += 10
        }
    }
}

#Preview {
    QA()
}
