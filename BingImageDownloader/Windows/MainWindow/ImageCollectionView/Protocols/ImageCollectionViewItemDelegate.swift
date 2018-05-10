//
//  ImageViewItemDelegate.swift
//  BingImageDownloader
//
//  Created by Michael James on 06/05/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Cocoa

protocol ImageCollectionViewItemDelegate {
    
    func imageClicked(_ image: ImageCollectionViewItem, with event: NSEvent)
    
    func imageRightClicked(_ image: ImageCollectionViewItem, with event: NSEvent)
}
