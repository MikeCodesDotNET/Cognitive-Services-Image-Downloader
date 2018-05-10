//
//  ImageCollectionViewDelegate.swift
//  BingImageDownloader
//
//  Created by Michael James on 06/05/2018.
//  Copyright © 2018 Mike JAmes. All rights reserved.
//

import Cocoa

protocol ImageCollectionViewDelegate {
    
    func keyPress(_ collectionView: ImageCollectionView, with event: NSEvent) -> Bool
    
    func preReloadData(_ collectionView: ImageCollectionView)
    
    func postReloadData(_ collectionView: ImageCollectionView)
    
    func drag(_ collectionView: ImageCollectionView, session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation)
    
}
