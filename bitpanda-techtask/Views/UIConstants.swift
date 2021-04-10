//
//  UIConstants.swift
//  bitpanda-techtask
//
//  Created by Blazej Wdowikowski on 08/04/2021.
//

import UIKit

struct UIConstants {
    struct Layout {
        static let margin: CGFloat = 12.0
        static let innerSpacing: CGFloat = 8.0
        static let animation: Double = 0.25
        
        struct Icon {
            static let width: CGFloat = 50.0
        }
        
        struct SegmentControl {
            static let height: CGFloat = 60.0
        }
    }
    
    struct Font {
        static let regular: UIFont = .systemFont(ofSize: 16)
        static let light: UIFont = .systemFont(ofSize: 13, weight: .light)
    }
}
