
//
//  ImageCollectionViewCell.swift
//  BingImageDownloader
//
//  Created by Michael James on 02/05/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Cocoa
import SDWebImage
import Alamofire

public class ImageCollectionViewItem : NSCollectionViewItem {
  
    var delegate : ImageCollectionViewItemDelegate? = nil
    var imageSearchResult : ImageSearchResult? = nil
    
    private static let frameColor = NSColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
    private static let unselectedBorderColor = NSColor(red:1.00, green:0.85, blue:0.90, alpha:1.00)
    private static let selectedBorderColor = NSColor(red: 0.234, green: 0.627, blue: 0.993, alpha: 1)
    private static let dragStartsAtDistance:CGFloat = 5.0

    // MARK: - Outlets
    @IBOutlet var imageResult: NSImageView!
    @IBOutlet var name: NSTextField!
    @IBOutlet var loadingSpinner: NSProgressIndicator!
    
    override public func prepareForReuse() {
        
       imageResult.image = nil
        name.stringValue = ""
    }
    
    func setData(result : ImageSearchResult){
        //Set the spinner to visible
        self.loadingSpinner.isHidden = false
        
        //Fetch & Set the image
        setImageFromUrl(imageUrl: result.thumbnailUrl)
        self.name.stringValue = result.name
        
        //Hide the spinner
        self.loadingSpinner.isHidden = true
    }
    
    func setImageFromUrl(imageUrl : String){
        
        //Attempt to fetch the image from the memory cache as this is the fastest approach
        if let image = SDImageCache.shared().imageFromMemoryCache(forKey: imageUrl) {
            imageResult.image = image
            return
        }
        
        //If not image in found in memory cache we can look on disk
        if let image = SDImageCache.shared().imageFromDiskCache(forKey: imageUrl) {
            imageResult.image = image
            return
        }
        
        //We don't have a copy of the image so we'll download and cache for next time
        Alamofire.download(imageUrl).responseData { response in
            if let data = response.result.value {
                let image = NSImage(data: data)
                if(image == nil){
                    //Whoops. TODO: Do something here
                }
                self.imageResult.image = image
                SDImageCache.shared().storeImageData(toDisk: data, forKey: imageUrl)
                }
                return
            }
        }
    
    override public func viewDidLoad() {
        view.wantsLayer = true
        view.layer?.backgroundColor = ImageCollectionViewItem.frameColor.cgColor
        view.layer?.cornerRadius = 4.0
        
        self.loadingSpinner.startAnimation(self)
    }
    
    override public var isSelected:Bool {
        didSet {
            updateBackground()
        }
    }
    
    override public var highlightState: NSCollectionViewItem.HighlightState {
        didSet {
            updateBackground()
        }
    }
    
    func updateBackground(){
        if isSelected || (highlightState == .forSelection){
            view.layer?.borderColor = ImageCollectionViewItem.selectedBorderColor.cgColor
            view.layer?.borderWidth = 4.0
        }
        else
        {
            view.layer?.borderColor = ImageCollectionViewItem.unselectedBorderColor.cgColor
            view.layer?.borderWidth = 0

        }
    }
    
    private(set) var hasBorder = false {
        didSet {
            updateBackground()
        }
    }
    
    // MARK: - NSResponder
    override public func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        self.delegate?.imageClicked(self, with: event)
    }
    
    override public func rightMouseDown(with event: NSEvent) {
        super.rightMouseDown(with: event)
        self.delegate?.imageRightClicked(self, with: event)
    }
    
}
