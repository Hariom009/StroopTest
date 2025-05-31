//
//  UpgradedStartView.swift
//  StroopTest
//
//  Created by Hari's Mac on 30.05.2025.
//

import SwiftUI

struct UpgradedStartView: View {
    let stroopviewColor = Color(red: 30.0 / 255.0, green: 0.0 / 255.0, blue: 36.0 / 255.0)
    @StateObject var TestCoolDown = TestCooldownManager()
    @State private var showTest = false
    @State private var countdown: Int? = nil
    @State private var animateCards = false
    @State private var animateButton = false
    @State private var floatingOffset: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var textShimmer = false
    
    var body: some View {
        ZStack {
            // Ultra-premium dark gradient
            RadialGradient(
                colors: [
                    Color(red: 0.08, green: 0.08, blue: 0.12),
                    Color(red: 0.04, green: 0.04, blue: 0.08),
                    Color.black
                ],
                center: .topLeading,
                startRadius: 100,
                endRadius: 800
            )
            .ignoresSafeArea()
            
            // Subtle mesh gradient overlay
            LinearGradient(
                colors: [
                    Color.purple.opacity(0.05),
                    Color.clear,
                    Color.blue.opacity(0.03),
                    Color.clear,
                    Color.indigo.opacity(0.04)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating orbs
            GeometryReader { geo in
                ForEach(0..<4, id: \.self) { i in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.04),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 4,
                                endRadius: 40
                            )
                        )
                        .frame(width: 80, height: 80)
                        .position(
                            x: CGFloat.random(in: 0...geo.size.width),
                            y: CGFloat.random(in: 0...geo.size.height)
                        )
                        .offset(y: floatingOffset)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 4...7))
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.5),
                            value: floatingOffset
                        )
                }
            }
            
            VStack(spacing: 0) {
                // Minimalist premium header
                VStack(spacing: 4) {
                    Text("ATTENTION")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(.white.opacity(0.4))
                        .tracking(4)
                        .scaleEffect(textShimmer ? 1.02 : 1.0)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: textShimmer)
                    
                    Text("TEST")
                        .font(.system(size: 48, weight: .ultraLight, design: .default))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color.white,
                                    Color.white.opacity(0.7),
                                    Color.white.opacity(0.9)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .tracking(-2)
                        .scaleEffect(animateCards ? 1 : 0.8)
                        .opacity(animateCards ? 1 : 0)
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
                
                ScrollView {
                    LazyVStack(spacing: 32) {
                        // Hero image with floating animation
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white.opacity(0.02))
                                .frame(height: 260)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.1),
                                                    Color.clear,
                                                    Color.white.opacity(0.05)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 0.5
                                        )
                                )
                            
                            Image("lvl4")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .scaleEffect(pulseScale)
                                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: pulseScale)
                        }
                        .scaleEffect(animateCards ? 1 : 0.9)
                        .opacity(animateCards ? 1 : 0)
                        .offset(y: animateCards ? 0 : 20)
                        .animation(.spring(response: 1.2, dampingFraction: 0.8).delay(0.2), value: animateCards)
                        
                        // Minimalist info cards
                        MinimalCard(
                            number: "01",
                            title: "About Test",
                            description: "Measure attention control and mental flexibility through color-word interference tasks.",
                            delay: 0.4
                        )
                        
                        MinimalCard(
                            number: "02",
                            title: "Rules",
                            description: "1. Quickly say the color of the ink, not the written word.\n2. Words can either match the ink color or differ, increasing difficulty.\n3. Speed and accuracy are measured to assess cognitive control and attention flexibility.",
                            delay: 0.6
                        )
                        
                       
                        MinimalCard(
                            number: "03",
                            title: "Voice Input",
                            description: "Speak color names clearly using the microphone for accurate response capture.",
                            delay: 0.8
                        )
                        MinimalCard(
                            number: "04",
                            title: "Executive Function",
                            description: "Assess brain's ability to suppress automatic responses and maintain focus.",
                            delay: 1
                        )
                        
                    }
                    .padding(.horizontal, 24)
                }
                .scrollIndicators(.hidden)
                
                // Ultra-minimal start button
                Button {
                    startCountdown()
                } label: {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 6, height: 6)
                            .scaleEffect(animateButton ? 1.5 : 1.0)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: animateButton)
                        
                        Text("BEGIN")
                            .font(.system(size: 13, weight: .medium, design: .monospaced))
                            .tracking(2)
                    }
                    .foregroundColor(.white.opacity(0.9))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.white.opacity(0.03))
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                            )
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .scaleEffect(animateCards ? 1 : 0.95)
                .opacity(animateCards ? 1 : 0)
                .animation(.spring(response: 1.0, dampingFraction: 0.7).delay(1.2), value: animateCards)
            }
            
            // Premium countdown
            if let count = countdown {
                ZStack {
                    Color.black.opacity(0.98)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 40) {
                        Text("PREPARE")
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundColor(.white.opacity(0.4))
                            .tracking(6)
                        
                        ZStack {
                            // Outer ring
                            Circle()
                                .stroke(Color.white.opacity(0.05), lineWidth: 1)
                                .frame(width: 180, height: 180)
                            
                            // Progress ring
                            Circle()
                                .trim(from: 0, to: CGFloat(4 - count) / 3)
                                .stroke(
                                    Color.white.opacity(0.8),
                                    style: StrokeStyle(lineWidth: 1, lineCap: .round)
                                )
                                .frame(width: 180, height: 180)
                                .rotationEffect(.degrees(-90))
                                .animation(.linear(duration: 1), value: count)
                            
                            // Count number
                            Text("\(count)")
                                .font(.system(size: 64, weight: .ultraLight, design: .default))
                                .foregroundColor(.white.opacity(0.9))
                                .scaleEffect(count == 3 ? 1.1 : 1.0)
                                .animation(.easeOut(duration: 0.3), value: count)
                        }
                    }
                }
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.9)),
                    removal: .opacity.combined(with: .scale(scale: 1.1))
                ))
            }
        }
        .onAppear {
            withAnimation(.spring(response: 1.5, dampingFraction: 0.8)) {
                animateCards = true
            }
            TestCooldownManager.shared.startNewCooldown()
            floatingOffset = -20
            pulseScale = 1.05
            textShimmer = true
            animateButton = true
        }
        .fullScreenCover(isPresented: $showTest) {
            UpdatedQA()
        }
    }
    
    private func startCountdown() {
        countdown = 3
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()

        Task {
            while let current = countdown, current > 0 {
                feedbackGenerator.impactOccurred() // 🌟 Trigger vibration
                try await Task.sleep(nanoseconds: 1_000_000_000)
                countdown! -= 1
            }
            
            try? await Task.sleep(nanoseconds: 500_000_000)
            countdown = nil
            showTest = true
        }
    }
}
#Preview {
    UpgradedStartView()
        .preferredColorScheme(.dark)
}
