//
//  FilterFreshness.swift
//  BingImageDownloader
//
//  Created by Michael James on 18/04/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Foundation

enum FilterFreshness: String {
    case unspecified
    case day
    case week
    case month
    
    func name() -> String {
        switch self {
        case .unspecified: return "Unspecified"
        case .day: return "Day"
        case .week: return "Week"
        case .month: return "Month"
        }
    }
    
    static func all() -> [FilterFreshness] {
        return [.unspecified, .day, .week, .month]
    }
}
