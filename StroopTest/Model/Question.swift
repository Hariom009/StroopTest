//
//  Question.swift
//  StroopTest
//
//  Created by Hari's Mac on 27.05.2025.
//

import Foundation
import Foundation
import SwiftUI
import FirebaseFirestore

struct Question: Identifiable, Codable {
    
    @DocumentID var id:String?
    var question: String?
    var optionA: String?
    var optionB: String?
    var answer: String?
    
    // for checking ...
    var isSubmitted = false
    var completed = false
    
   enum CodingKeys: String, CodingKey {
        case question
        case optionA = "a"
        case optionB = "b"
        case answer
    }
}
