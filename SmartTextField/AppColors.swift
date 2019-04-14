//
//  AppColors.swift
//  SmartTextField
//
//  Created by Nutan Niraula on 4/14/19.
//  Copyright © 2019 Nutan Niraula. All rights reserved.
//

import UIKit

struct AppColors {
    
    struct TextField {
        static let highlightColor = UIColor(hexString: "00AAFF", alpha: 1.0)
        static let warningColor = UIColor(hexString: "A94443", alpha: 1.0)
        static let green = UIColor(hexString: "3D763D", alpha: 1.0)
        static let borderColor = UIColor.lightGray
    }
    
}

extension UIColor {
    
    convenience init(hexString: String, alpha: CGFloat) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            ( r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            ( r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            ( r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: alpha)
    }
    
}
