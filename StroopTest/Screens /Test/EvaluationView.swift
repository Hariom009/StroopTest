//
//  EvaluationView.swift
//  StroopTest
//
//  Created by Hari's Mac on 29.05.2025.
//

import SwiftUI
import Foundation

struct EvaluationView: View {
    @Environment(\.dismiss) private var dismiss
    @State var progress: Double = 0.01
    @Binding var Score: Int
    @Binding var totalQuestion:Int
    @Binding var correctQuestion:Int
    @State var showScore = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(spacing: 12) {
                Text("Analyzing your score for the Stroop test ...")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                ReliableAnimatedCircularProgressView(progress: $progress, onCompletion: {
                    // This will be called when progress reaches 100%
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showScore = true
                    }
                })
                
                Spacer()
                
                Text("Calculating score...")
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showScore) {
            ScoreView(score: $Score, totalQuestions: $totalQuestion, correctAnswers: $correctQuestion)
        }
        .onAppear {
            // Auto-start the progress animation when view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // This will trigger the progress animation to start
            }
        }
    }
}

#Preview {
    EvaluationView(Score: .constant(0), totalQuestion: .constant(1), correctQuestion: .constant(0))
        .preferredColorScheme(.dark)
}
