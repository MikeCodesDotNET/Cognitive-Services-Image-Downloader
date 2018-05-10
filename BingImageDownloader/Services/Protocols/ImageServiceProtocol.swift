//
//  ImageServiceProtocol.swift
//  BingImageDownloader
//
//  Created by Michael James on 23/04/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Foundation
import AppKit

protocol ImageServiceProtocol {
    
    func searchForImageTerm(searchTerm : String)
    
    func searchForImageTerm(searchTerm : String, completion : @escaping ([ImageSearchResult]) -> ()) 

}
