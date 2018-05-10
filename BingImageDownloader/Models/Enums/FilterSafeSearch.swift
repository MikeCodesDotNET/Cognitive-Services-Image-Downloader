//
//  FilterSafeSearch.swift
//  BingImageDownloader
//
//  Created by Michael James on 18/04/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Foundation

enum FilterSafeSearch: String {
    case strict
    case moderate
    case off
    
    func name() -> String {
        switch self {
        case .strict: return "Strict"
        case .moderate: return "Moderate"
        case .off: return "Off"
        }
    }
    
    static func all() -> [FilterSafeSearch] {
        return [.strict, .moderate, .off]
    }
}
