//
//  AppData.swift
//  BingImageDownloader
//
//  Created by Michael James on 05/05/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Foundation
import Alamofire
import SDWebImage
import SwiftyBeaver

class AppData : NSObject {

    static let shared = AppData()
    private var allImagesArray = [ImageSearchResult]()
    let log = SwiftyBeaver.self
    
    func clearAll() -> Bool {
        allImagesArray.removeAll()
        imagesDidChange()
        return true
    }
    
    var allImageResults : [ImageSearchResult]{
        get {
            return allImagesArray
        }
    }
    
    var selectedIndexPaths : [IndexPath]? = nil

    func addImages(_ images: [ImageSearchResult]) {
        for image in images {
            self.addImage(image)
        }
    }
    
    func addImage(_ image : ImageSearchResult) {
        
        Alamofire.download(image.thumbnailUrl).responseData { response in
            if let data = response.result.value {
                SDImageCache.shared().storeImageData(toDisk: data, forKey: image.thumbnailUrl)
            }
        }
        
        allImagesArray.append(image)
        imagesDidChange()
    }
    
    func removeImage(_ image : ImageSearchResult) -> Bool {
        imagesDidChange()
        return false
    }
    
    func imageAt(withIndexPath indexPath: IndexPath) -> ImageSearchResult?{
        
        return allImagesArray[indexPath.item]
    }
    
    private func imagesDidChange()
    {
        NotificationCenter.default.post(name: .appDataImagesChanged, object: nil)
    }
    
    func exportSelectedImages()
    {
        for selection in selectedIndexPaths! {
            let item = allImagesArray[selection.item]
            
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let documentsURL = URL(fileURLWithPath: UserDefaults.standard.getDefaultOutputDirectory(), isDirectory : true)
                let fileURL = documentsURL.appendingPathComponent("\(item.name).\(item.encodingFormat)")
                
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            Alamofire.download(item.contentUrl, to: destination).response { response in
                //Handle response...
            }

        }
        
        log.info("Exported \(selectedIndexPaths?.count ?? -1) Images to disk")   // prio 3, INFO in blue

        dialogOKCancel(question: "Ok", text: "Downloaded \(selectedIndexPaths?.count ?? -1) Images")
    }
    
    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert: NSAlert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "OK")
        let res = alert.runModal()
        if res == NSApplication.ModalResponse.alertFirstButtonReturn {
            return true
        }
        return false
    }
}
