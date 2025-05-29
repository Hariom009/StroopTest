//
//  StroopTestApp.swift
//  StroopTest
//
//  Created by Hari's Mac on 27.05.2025.
//

import SwiftUI
import UIKit
@main
struct StroopTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = UIColor.clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
