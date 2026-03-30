//
//  RoutineHistory+RateColor.swift
//  Rouzzle_iOS
//
//  Created by Copilot.
//

import SwiftUI
import Entity

extension RoutineHistory {
    var rateColor: Color {
        switch completeRate {
        case 0..<29:
            return .accentColor.opacity(0.3)
        case 30..<60:
            return .accentColor.opacity(0.6)
        default:
            return .accentColor
        }
    }
}
