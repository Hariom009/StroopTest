//
//  StroopTestView.swift
//  Quiz
//
//  Created by Hari's Mac on 26.05.2025.
//

import SwiftUI
import SwiftUISpeechToText

struct HomeView: View {
    @State private var answerDone = 0
    @State private var correct = 0
    @State private var wrong = 0
    @State private var speechText = ""
    @State private var recordedAnswer = ""
    @StateObject var stroopData = StroopviewModel()
    
    var body: some View {
        //TranscribedTextFieldView(searchText: $speechText)
        
        ZStack{
            if stroopData.stroopQuestions.isEmpty{
                ProgressView()
            }else{
                if answerDone == $stroopData.stroopQuestions.count{
                    VStack(spacing: 25){
                        if correct < 10{
                            Image("trophy")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250,height: 250)
                        }else if correct >= 10 && correct < 13{
                            Image("happyface")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250,height: 250)
                        }else{
                            Image("sadgirl")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250,height: 250)
                        }
                        
                        if correct < 10 {
                            Text("Have a nice day!!!")
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                        }else if correct >= 10 && correct <= 12{
                            Text("Manage you stress please!!!")
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(.black)
                        }else if  correct >= 13 && correct <= 14 {
                            Text("Are you all alright ?")
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                        }else if correct > 14{
                            Text("Huhhh We are all the same bro don't be so tensed.")
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                        }
                        // Score and back to home screen...
                        HStack{
                            Text(" Score : \(correct)")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        VStack(alignment: .leading, spacing: 30){
                            HStack{
                                Text("Scale:")
                                    .font(.title2)
                                    .fontWeight(.heavy)
                                Spacer()
                            }
                            Text("😃 < 10 Balance mood")
                                .font(.caption)
                            Text("😕 10-12 Slightly Stressed")
                                .font(.caption)
                            Text("😩 < 12-14 Moderate Depressed")
                                .font(.caption)
                            Text("😢 >14 Feeling really bad , at the edge")
                                .font(.caption)
                            
                        }
                        .padding()
                        Spacer()
                    }
                }
                else {
                    VStack{
                        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center), content: {
                            Capsule()
                                .fill(Color.gray.opacity(0.7))
                                .frame(height: 6)
                            Capsule()
                                .fill(Color.green)
                                .frame(width: progress(),height: 6)
                            
                        })
                        .padding()
                        // Question View...
                        ZStack{
                            ForEach(stroopData.stroopQuestions.reversed().indices){ index in
                                // View...
                                QuestionView(question: $stroopData.stroopQuestions[index], correct: $correct, wrong: $wrong, answered: $answerDone,recordedAnswer: $recordedAnswer, imageIndex:index)
                                // if current question is completed means moving away...
                                    .offset(x:stroopData.stroopQuestions[index].completed ? 1000: 0)
                                    .rotationEffect(.init(degrees: stroopData.stroopQuestions[index].completed ? 10: 0))
                            }
                        }
                    }
                }
            }
        }
        // fetching the questions and options here ...
        .onAppear {
            stroopData.getQuestions(set: "Stroop")
        }
    }
    func progress()-> CGFloat {
        let fraction = CGFloat(answerDone) / CGFloat(stroopData.stroopQuestions.count)
        
        let width = UIScreen.main.bounds.width - 30
        
        return fraction * width
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}

