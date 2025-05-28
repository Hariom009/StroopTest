//
//  StartText.swift
//  StroopTest
//
//  Created by Hari's Mac on 28.05.2025.
//

import SwiftUI

struct StartTest: View {
    let stroopviewColor = Color(red:0.2,green: 0.3, blue: 0.4)
    @State private var showTest = false
    @State private var countdown: Int? = nil
    var body: some View {
        ZStack{
            stroopviewColor.opacity(0.8)
                .ignoresSafeArea()
            VStack{
                ScrollView{
                    VStack(alignment: .leading){
                        HStack{
                            Text("Stroop Test")
                                .font(.system(size: 25, weight: .heavy))
                            Spacer()
                        }.padding()
                        ZStack{
                            HStack{
                                Spacer()
                                Image("lvl4")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 380)
                                Spacer()
                            }
                        }
                    }
                    VStack(alignment: .leading,spacing: 10){
                        Text("🧠 What is the Stroop Test?")
                        Text("The Stroop Test is a psychological task that measures your attention, processing speed, and cognitive flexibility. You'll be asked to identify the color of a word, not the word itself even when the word spells a different color (e.g., the word Red written in blue).\nIt's a fun but challenging way to test how well your brain handles conflicting information!")
                            .font(.system(size: 12))
                        
                    }
                    .padding()
                    .foregroundStyle(stroopviewColor)
                    .frame(width:380,height: 170)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                    )
                    VStack(alignment: .leading,spacing: 12){
                        Text("How to take the Stroop Test ?")
                            .fontWeight(.semibold)
                        Text("1. You’ll see words that name colors — like “Red,” “Blue,” or “Green.")
                            .font(.system(size: 12))
                        Text("2. Your task is to select the color of the text, not the word itself.\nFor example:If the word Green is written in red color, the correct answer is Red, not Green")
                            .font(.system(size: 12))
                        Text("3. Stay focused and respond quickly, but try to be accurate.")
                            .font(.system(size: 12))
                        Text("4. The test gets challenging because your brain wants to read the word instead of identifying the color — this helps measure your attention and control.")
                            .font(.system(size: 12))
                        
                    }
                    .padding()
                    .foregroundStyle(stroopviewColor)
                    .frame(width:380,height: 260)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                    )
                    
                    VStack(alignment: .leading, spacing: 12){
                        Text("Advantages of this test")
                            .fontWeight(.semibold)
                        Text("1. Measures Cognitive Control")
                        Text("It effectively assesses your ability to focus, filter distractions, and control impulsive responses.")
                            .font(.system(size: 12))
                        Text("2. Tests Mental Flexibility")
                        Text("It evaluates how well your brain can switch between competing tasks — like reading a word vs. identifying its color.")
                            .font(.system(size: 12))
                        Text("3. Detects Attention-Related Issues")
                        Text("It’s commonly used to screen for conditions like ADHD, brain injuries, or cognitive decline.")
                            .font(.system(size: 12))
                        Text("4. Fun and Engaging")
                        Text("Despite its simplicity, the challenge makes it engaging and interactive for users of all ages.")
                            .font(.system(size: 12))
                    }
                    .foregroundStyle(stroopviewColor)
                    .padding()
                    .frame(width:380,height: 380)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                    )
                    VStack(alignment: .leading, spacing: 12){
                        Text("Answer method🗒️")
                            .foregroundStyle(stroopviewColor)
                        Text("You'll get a mic button to record your voice.\n🎙️Press the button to record the answer and click next to proceed to next question.")
                            .font(.system(size: 14))
                            .foregroundStyle(stroopviewColor)
                        
                    }
                    .padding()
                    .frame(width:380,height: 135)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                    )
                }
                .scrollIndicators(.hidden)
                Button{
                    startCountdown()
                }label: {
                    Text("Start Test")
                        .background(Color.clear)
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black)
                        )
                }
            }// VStack
            
            .sheet(isPresented: $showTest){
                QA()
            }
            if let count = countdown {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                Text("\(count)")
                    .font(.system(size: 120, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: countdown)
    }
private func startCountdown() {
      countdown = 3

      // Use async/await for clarity
      Task {
          while let current = countdown, current > 0 {
              try await Task.sleep(nanoseconds: 1_000_000_000)
              countdown! -= 1
          }
          // Small pause on “0” frame if you like:
          try? await Task.sleep(nanoseconds: 300_000_000)
          countdown = nil       // hide overlay
          showTest = true       // show the QA sheet
      }
  }
}

#Preview {
    StartTest()
}
