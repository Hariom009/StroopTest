//
//  Score.swift
//  StroopTest
//
//  Created by Hari's Mac on 01.06.2025.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Score: ObservableObject
{
   var number : Int
   var TestDate : Date
    
    init(number : Int,TestDate : Date)
    {
        self.number = number
        self.TestDate = TestDate
    }
}
