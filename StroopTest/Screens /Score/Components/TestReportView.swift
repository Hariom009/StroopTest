//
//  TestReportView.swift
//  StroopTest
//
//  Created by Hari's Mac on 29.05.2025.
//

import SwiftUI

struct TestReportView: View {
    @Binding var reportOpacity: Double
    @Binding var totalQuestions : Int
    @Binding var animatedCorrect : Int
    @Binding var animatedWrong : Int
    @Binding var reportScale : CGFloat
    
    var body: some View {
        VStack(spacing: 20) {        // slightly tighter than 25
            HStack {
                Text("Test Report")
                    .font(.title2).fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .opacity(reportOpacity)
                Spacer()
            }
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 1),
                    GridItem(.flexible(), spacing: 1),
                    GridItem(.flexible(), spacing: 1)
                ],
                spacing: 2
            ) {
                StatCard(
                    icon: "questionmark.circle.fill",
                    title: "Attempted",
                    value: "\(totalQuestions)",
                    color: .blue,
                    animatedValue: totalQuestions
                )
                StatCard(
                    icon: "checkmark.circle.fill",
                    title: "Correct",
                    value: "\(animatedCorrect)",
                    color: .green,
                    animatedValue: animatedCorrect
                )
                StatCard(
                    icon: "xmark.circle.fill",
                    title: "Wrong",
                    value: "\(animatedWrong)",
                    color: .red,
                    animatedValue: animatedWrong
                )
            }
            .scaleEffect(reportScale)
            .opacity(reportOpacity)
        }
    }
}

#Preview{
    TestReportView(reportOpacity: .constant(0.8), totalQuestions: .constant(10), animatedCorrect: .constant(10), animatedWrong: .constant(5), reportScale: .constant(1))
        .preferredColorScheme(.dark)
}
