//
//  ImageSearchResult.swift
//  BingImageDownloader
//
//  Created by Michael James on 02/05/2018.
//  Copyright © 2018 Mike JAmes. All rights reserved.
//

import Cocoa
import Alamofire


// MARK: - Bing Image Search Result Model
struct ImageSearchResult : Codable {
    
    let name : String
    let datePublished : String
    let encodingFormat : EncodingFormat
    let imageId : String
    let accentColor : String
    let webSearchUrl : String
    let thumbnailUrl : String
    let contentUrl : String
    let width : Int
    let height : Int
    
    init (name : String, datePublished : String, encodingFormat : EncodingFormat, imageId : String, accentColor : String, webSearchUrl : String, thumbnailUrl : String,  contentUrl : String, width : Int, height : Int){
        
        self.name = name
        self.datePublished = datePublished
        self.encodingFormat = encodingFormat
        self.imageId = imageId
        self.accentColor = accentColor
        self.webSearchUrl = webSearchUrl
        self.thumbnailUrl = thumbnailUrl
        self.contentUrl = contentUrl
        self.width = width
        self.height = height
    }
    
}

