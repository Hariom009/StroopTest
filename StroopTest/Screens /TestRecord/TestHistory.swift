//
//  TestHistory.swift
//  StroopTest
//
//  Created by Hari's Mac on 01.06.2025.
//

import SwiftUI
import SwiftData


struct TestHistory: View {
    @Query var Scores: [Score]
    
    var body: some View {
        ScrollView{
            VStack{
                ForEach(Scores, id: \.self){ each in
                    HStack{
                        Text("\(each.number)")
                        Spacer()
                        Text("\(each.TestDate.displayDate)")
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Test History")
    }
}
extension Date {
    var displayDate: String {
        self.formatted(.dateTime.day().month(.wide).year())
    }
}

#Preview {
    let modelContainer = try! ModelContainer(for: Score.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = modelContainer.mainContext
    context.insert(Score(number: 65, TestDate: Date.now))
   return TestHistory()
        .modelContainer(modelContainer)
}
