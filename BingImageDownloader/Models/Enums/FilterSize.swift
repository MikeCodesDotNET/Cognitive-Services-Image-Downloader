//
//  FilterSize.swift
//  BingImageDownloader
//
//  Created by Michael James on 18/04/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Foundation

enum FilterSize: String {
    case unspecified
    case small
    case medium
    case large
    case wallpaper
    
    func name() -> String {
        switch self {
        case .unspecified: return "Unspecified"
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        case .wallpaper: return "Wallpaper"
        }
    }
    
    static func all() -> [FilterSize] {
        return [.unspecified, .small, .medium, .large, .wallpaper]
    }
}
