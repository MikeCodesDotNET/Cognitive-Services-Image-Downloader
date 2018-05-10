//
//  FilterImageType.swift
//  BingImageDownloader
//
//  Created by Michael James on 18/04/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Foundation

enum FilterImageType: String {
    case animatedGif
    case clipArt
    case line
    case photo
    
    func name() -> String {
        switch self {
        case .animatedGif: return "Animated Gif"
        case .clipArt: return "Clip Art"
        case .line: return "Line"
        case .photo: return "Photo"
        }
    }
    
    static func all() -> [FilterImageType] {
        return [.animatedGif, .clipArt, .line, .photo]
    }
}
