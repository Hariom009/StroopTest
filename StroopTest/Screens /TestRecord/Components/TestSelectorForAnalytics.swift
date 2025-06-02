//
//  TestSelectorForAnalytics.swift
//  StroopTest
//
//  Created by Hari's Mac on 02.06.2025.
//

import SwiftUI

struct TestSelectorForAnalytics: View {
    let tests = ["Attention Test", "Memory Test", "ADHD Test", "Focus Test"]
    @Binding var selectedTestType: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(tests, id: \.self) { test in
                    TestSelectorButton(
                        testName: test,
                        isSelected: selectedTestType == test
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selectedTestType = test
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 8)
    }
}

struct TestSelectorButton: View {
    let testName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                // Icon for each test type
                Image(systemName: iconForTest(testName))
                    .font(.system(size: 14, weight: .medium))
                
                Text(testName)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background {
                if isSelected {
                    // Selected state with gradient
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [.purple, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .purple.opacity(0.4), radius: 8, x: 0, y: 4)
                } else {
                    // Unselected state with glassmorphism
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .dark)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    LinearGradient(
                                        colors: [.white.opacity(0.2), .white.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        }
                }
            }
            .foregroundColor(isSelected ? .white : .primary)
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
    
    private func iconForTest(_ testName: String) -> String {
        switch testName {
        case "Attention Test":
            return "eye.fill"
        case "Memory Test":
            return "brain.head.profile"
        case "ADHD Test":
            return "bolt.fill"
        case "Focus Test":
            return "target"
        default:
            return "testtube.2"
        }
    }
}

#Preview {
    @State var selectedTest = "Attention Test"
    
    return VStack {
        TestSelectorForAnalytics(selectedTestType: $selectedTest)
        
        Spacer()
        
        Text("Selected: \(selectedTest)")
            .foregroundColor(.white)
    }
    .background(Color.black)
    .preferredColorScheme(.dark)
}
