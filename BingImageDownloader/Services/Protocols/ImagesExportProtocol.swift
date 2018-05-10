//
//  ImagesExportProtocol.swift
//  BingImageDownloader
//
//  Created by Michael James on 23/04/2018.
//  Copyright © 2018 Mike JAmes. All rights reserved.
//

import Foundation
import AppKit

protocol ImagesExportProtocol {
    
    func exportImages(images : Array<NSImage>, outputDirectory : String) -> Bool
    
}
