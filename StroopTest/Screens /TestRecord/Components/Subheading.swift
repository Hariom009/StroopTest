//
//  Subheading.swift
//  StroopTest
//
//  Created by Hari's Mac on 02.06.2025.
//

import SwiftUI

struct Subheading: View {
     var Scores : [Score]
    var body: some View {
        HStack {
            Text("Test History")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            Text("\(Scores.count) tests")
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .clipShape(Capsule())
        }
    }
}
