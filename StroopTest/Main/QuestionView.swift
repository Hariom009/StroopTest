import SwiftUI
import SwiftUISpeechToText

struct QuestionView: View {
    @Binding var question: Question
    @Binding var correct: Int
    @Binding var wrong: Int
    @Binding var answered: Int
    @Binding var recordedAnswer:String
    var imageIndex: Int
    @State private var selected = ""
    let mycustomColor = Color(red: 0.2745, green: 0.3922, blue: 0.5725)
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 22) {
            Text(question.question ?? "No question available")
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundStyle(.white)
                .padding(.top, 25)

            Spacer(minLength: 0)

             Image("\(imageIndex)")
                .resizable()
                .frame(width: 350, height: 350)
                .padding()
            TranscribedTextFieldView(searchText: $recordedAnswer)
            Spacer(minLength: 0)
            // Action Buttons
            HStack(spacing: 15) {
                Button(action: checkAns) {
                    Text("Submit")
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                .disabled(question.isSubmitted)
                .opacity(question.isSubmitted ? 0.7 : 1)

                Button(action: {
                    withAnimation {
                        question.completed.toggle()
                        answered += 1
                    }
                }) {
                    Text("Next")
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
              //  .disabled(!question.isSubmitted)
             //   .opacity(!question.isSubmitted ? 0.7 : 1)
            }
            .padding(.bottom)
        }
        .padding()
        .background(Color.indigo)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 5, y: 5)
        .shadow(color: Color.black.opacity(0.08), radius: 5, x: -5, y: -5)
    }

    // MARK: - Option Button
    @ViewBuilder
    func optionButton(option: String) -> some View {
        Button(action: {
            if !question.isSubmitted {
                selected = option
            }
        }) {
            Text(option)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(color(option: option), lineWidth: 2)
                )
        }
    }

    // MARK: - Answer Highlight Logic
    func color(option: String) -> Color {
        guard question.isSubmitted else {
            return option == selected ? .white : .gray
        }

        if option == question.answer {
            return .green
        } else if option == selected {
            return .red
        } else {
            return .gray
        }
    }

    // MARK: - Answer Submission Logic
    func checkAns() {
        if recordedAnswer == question.answer {
            correct += 2
        }else {
            wrong += 1
        }

        question.isSubmitted = true
    }
}

