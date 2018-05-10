//
//  EncodingFormat.swift
//  BingImageDownloader
//
//  Created by Michael James on 02/05/2018.
//  Copyright © 2018 Mike JAmes. All rights reserved.
//

import Foundation

enum EncodingFormat : String, Codable {
    case jpeg = "jpeg"
    case png = "png"
    case gif = "gif"
    case animatedGif = "animatedgif"
    case bmp = "bmp"
    case unknown = "unknown"
}
