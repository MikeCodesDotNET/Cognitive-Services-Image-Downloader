//
//  KeyBindingsExtensions.swift
//  BingImageDownloader
//
//  Created by Michael James on 06/05/2018.
//  Copyright © 2018 Mike JAmes. All rights reserved.
//

import Cocoa
import Quartz

extension MainWindowController : ImageCollectionViewDelegate {
        
    func keyPress(_ collectionView: ImageCollectionView, with event: NSEvent) -> Bool {
        switch event.keyCode {
        case 49:    // SPACE
            if self.quickLookActive {
                QLPreviewPanel.shared().close()
            } else {
                QLPreviewPanel.shared().makeKeyAndOrderFront(self)
            }
            return true
        case 51, 117:    // Backspace, Delete
            //AppData.shared.selec()
            return true
        default:
            return false
        }
        
    }
    
    func preReloadData(_ collectionView: ImageCollectionView) {
        /*
        reloadHelperArray = [ImageData]()
        for indexPath in collectionView.selectionIndexPaths {
            if    let item = collectionView.item(at: indexPath),
                let object = item.representedObject as? ImageSearchResult
            {
                reloadHelperArray.append(object)
            }
        }
 */
    }
    
    func postReloadData(_ collectionView: ImageCollectionView) {
        /*
        var indexPaths = Set<IndexPath>()
        
        for imageData in reloadHelperArray {
            if let indexPath = AppData.shared.imageCollection.indexPath(of: imageData) {
                indexPaths.insert(indexPath)
            }
        }
        if AppData.shared.imageCollection.count > 0 {
            dropView.hide()
        }
        else {
            dropView.show()
        }
        collectionView.selectItems(at: indexPaths, scrollPosition: [])
        self.didSelectItems(indexPaths)
 */
    }
    
    func drag(_ collectionView: ImageCollectionView, session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        if operation == .delete {
            // Dragging session ended with delete operation (user dragged the icon to the trash)
            if let pictureURLs:[NSURL] = session.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [NSURL] {
                var filePathList = [String]()
                for pictureURL in pictureURLs {
                    if let path = pictureURL.path {
                        filePathList.append(path)
                    }
                }
            //ppData.shared.deleteSelected()
            }
        }
    }
    
}
