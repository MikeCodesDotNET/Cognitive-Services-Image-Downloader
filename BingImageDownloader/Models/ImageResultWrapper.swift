//
//  ImageResultWrapper.swift
//  BingImageDownloader
//
//  Created by Michael James on 02/05/2018.
//  Copyright © 2018 Mike JAmes. All rights reserved.
//

import Foundation


// MARK: - Bing Image Search Result Page Model
struct ImageResultWrapper  {
    
    let type : String
    let webSearchUrl : String
    let images : [ImageSearchResult]
    let totalEstimatedMatches : Int
    let nextOffset : Int
    
    init(type : String, webSearchUrl : String, images : [ImageSearchResult], totalEstimatedMatches : Int, nextOffset : Int){
        self.type = type
        self.webSearchUrl = webSearchUrl
        self.images = images
        self.totalEstimatedMatches = totalEstimatedMatches
        self.nextOffset = nextOffset
    }
    
    enum CodingKeys: String, CodingKey {
        case type = "_type"
        case webSearchUrl = "webSearchUrl"
        case images = "value"
        case totalEstimatedMatches = "totalEstimatedMatches"
        case nextOffset = "nextOffset"
    }
}

extension ImageResultWrapper: Decodable {
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(String.self, forKey: .type)
        webSearchUrl = try values.decode(String.self, forKey: .webSearchUrl)
        totalEstimatedMatches = try values.decode(Int.self, forKey: .totalEstimatedMatches)
        nextOffset = try values.decode(Int.self, forKey: .nextOffset)

        images = try values.decode([ImageSearchResult].self, forKey: .images)
    }
}

