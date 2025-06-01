//
//  StroopTestApp.swift
//  StroopTest
//
//  Created by Hari's Mac on 27.05.2025.
//

import SwiftUI
import UIKit
import SwiftData

@main
struct StroopTestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [Score.self])
    }
}
