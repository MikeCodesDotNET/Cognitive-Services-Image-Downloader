//
//  ImageCollectionView.swift
//  BingImageDownloader
//
//  Created by Michael James on 06/05/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Cocoa

class ImageCollectionView: NSCollectionView {
    
    var keyDelegate:ImageCollectionViewDelegate? = nil
    
    override func keyDown(with event: NSEvent) {
        var eventHandled = false
        if let delegate = self.keyDelegate {
            eventHandled = delegate.keyPress(self, with: event)
        }
        if !eventHandled {
            super.keyDown(with: event)
        }
    }
    
    override func reloadData() {
        keyDelegate?.preReloadData(self)
        super.reloadData()
        keyDelegate?.postReloadData(self)
    }
    
    //MARK: - Dragging
    override func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        switch(context) {
        case .outsideApplication:
            return [ .copy, .link, .generic, .delete, .move ]
        case .withinApplication:
            return .move
        }
    }
    
    override func draggingSession(_ session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        keyDelegate?.drag(self, session: session, endedAt: screenPoint, operation: operation)
    }
    
}
