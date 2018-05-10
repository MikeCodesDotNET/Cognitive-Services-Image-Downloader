//
//  QuickLookExtensions.swift
//  BingImageDownloader
//
//  Created by Michael James on 06/05/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Foundation
import Quartz

extension MainWindowController : QLPreviewPanelDelegate {
    
    public func previewPanel(_ panel: QLPreviewPanel!, handle event: NSEvent!) -> Bool {
        let splitViewController = self.contentViewController as! NSSplitViewController
        let viewController = splitViewController.splitViewItems[0].viewController as! ImageCollectionViewController
        
        if event.type == .keyDown {
            viewController.imageCollectionView.keyDown(with: event)
            return true
        }
        if event.type == .keyUp {
            viewController.imageCollectionView.keyUp(with: event)
            print("Key up")
            return true
        }
        return false
    }
}

extension MainWindowController : QLPreviewPanelDataSource {
    public func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        let splitViewController = self.contentViewController as! NSSplitViewController
        let viewController = splitViewController.splitViewItems[0].viewController as! ImageCollectionViewController
        
        return viewController.selectedImages().count
    }
    
    public func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        let splitViewController = self.contentViewController as! NSSplitViewController
        let viewController = splitViewController.splitViewItems[0].viewController as! ImageCollectionViewController
        
        let images = viewController.selectedImages()
        if index < images.count {
            return (URL(fileURLWithPath: images[index].contentUrl) as QLPreviewItem??)!
        }
        return nil
    }
}
