//
//  Color+Extension.swift
//  Rouzzle
//
//  Created by 김정원 on 11/3/24.
//

import SwiftUI

private extension Color {
    static func asset(_ name: String) -> Color {
        return Color(name)
    }
}

extension Color {
    // MARK: - Legacy aliases (legacy codebase compatibility)
    static var accent: Color {
        return .accentColor
    }
    
    static var basic: Color {
        return Color("basic")
    }
    
    static var rzf9F9F9: Color {
        return Color("rzf9f9f9")
    }
    
    static var rzfcfff0: Color {
        return Color("rzfcfff0")
    }
    
    static var rz999999: Color {
        return Color("rz999999")
    }
    
    static var rzc1C1C1: Color {
        return Color("rzc1c1c1")
    }
    
    static var rzd9D9D9: Color {
        return Color("rzd9d9d9")
    }
    
    static var rz747272: Color {
        return Color("rz747272")
    }
    
    static var rz1F1F1F: Color {
        return Color("rz1f1f1f")
    }
    
    static var rze1E1E1: Color {
        return Color("rze1e1e1")
    }
    
    static var rzc9C9C9: Color {
        return Color("rzc9c9c9")
    }
    
    static var rz3B3D4A: Color {
        return Color("rz3b3d4a")
    }
    
    static var rz558A24: Color {
        return Color("rz558a24")
    }
    
    static var RZFAFAFA: Color {
        return Color("RZFAFAFA")
    }
    
    static var overtimeText: Color {
        return Color("overtimeTextColor")
    }

    /// Legacy compatibility aliases (mixed-case references kept in source)
    static var rzc1c1c1: Color { rzc1C1C1 }
    static var rzd9d9d9: Color { rzd9D9D9 }
    static var rz999999Lower: Color { rz999999 }
    static var rz1f1f1f: Color { rz1F1F1F }
    
    /// RGB 컬러 형태로 나타낼 때 사용하는 메서드 기본 투명도는 1임.
    static func fromRGB(r: Double, g: Double, b: Double, opacity: Double = 1) -> Color {
        return Color(red: r/255, green: g/255, blue: b/255, opacity: opacity)
    }
    
    static var subHeadlineFontColor: Color {
        return .fromRGB(r: 153, g: 153, b: 153)
    }
    
    static var themeColor: Color {
        return .fromRGB(r: 193, g: 235, b: 96)
    }
    
    /// F9F9F9
    static var backgroundLightGray: Color {
        return .fromRGB(r: 249, g: 249, b: 249)
    }
    
    /// BFDF8F
    static var partiallyCompletePuzzle: Color {
        return .fromRGB(r: 217, g: 255, b: 160)
    }
    
    /// 121212
    static var subBlack: Color {
        return .fromRGB(r: 18, g: 18, b: 18)
    }
    
    static var chart: Color {
        return .fromRGB(r: 143, g: 191, b: 71)
    }
    
    static var calendarCompleted: Color {
        return .fromRGB(r: 157, g: 210, b: 78)
    }
}

// MARK: - Legacy aliases for ShapeStyle-inferred call-sites
extension ShapeStyle where Self == Color {
    static var accentColor: Color { Color.accentColor }
    static var accent: Color { Color.accent }
    static var basic: Color { Color.basic }
    static var rzf9F9F9: Color { Color.rzf9F9F9 }
    static var rzfcfff0: Color { Color.rzfcfff0 }
    static var rz999999: Color { Color.rz999999 }
    static var rzc1C1C1: Color { Color.rzc1C1C1 }
    static var rzd9D9D9: Color { Color.rzd9D9D9 }
    static var rz747272: Color { Color.rz747272 }
    static var rz1F1F1F: Color { Color.rz1F1F1F }
    static var rze1E1E1: Color { Color.rze1E1E1 }
    static var rzc9C9C9: Color { Color.rzc9C9C9 }
    static var rz3B3D4A: Color { Color.rz3B3D4A }
    static var rz558A24: Color { Color.rz558A24 }
    static var RZFAFAFA: Color { Color.RZFAFAFA }
    static var overtimeText: Color { Color.overtimeText }
}
