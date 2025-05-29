//
//  ButtonLablegradient.swift
//  StroopTest
//
//  Created by Hari's Mac on 30.05.2025.
//

import SwiftUI

struct ButtonLablegradient: View {
    @State var buttonName: String
    @State var systemimage: String
    var body: some View {
        Label("\(buttonName)", systemImage: "\(systemimage)")
            .font(.system(size: 10))
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .foregroundColor(.white)
    }
}

#Preview {
    ButtonLablegradient(buttonName: "Share Report", systemimage: "square.and.arrow.up")
}
