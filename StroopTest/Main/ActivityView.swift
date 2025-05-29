//
//  ActivityView.swift
//  StroopTest
//
//  Created by Hari's Mac on 29.05.2025.
//

// MARK: - ShareSheet.swift (Separate file)
import SwiftUI
import UIKit

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        
        // Add completion handler to dismiss the sheet when done
        controller.completionWithItemsHandler = { _, _, _, _ in
            isPresented = false
        }
        
        // Exclude certain activity types if needed
        // controller.excludedActivityTypes = [.addToReadingList, .assignToContact]
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
