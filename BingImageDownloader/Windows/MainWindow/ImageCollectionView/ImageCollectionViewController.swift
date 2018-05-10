//
//  ViewController.swift
//  BingImageDownloader
//
//  Created by Michael James on 17/04/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Cocoa
import SwiftyBeaver

protocol imageSeletionDelegate: class {
    func updateSelected(items : [IndexPath])
}

class ImageCollectionViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {

    weak var delegate : imageSeletionDelegate?
    
    var imageSearchResults = [ImageSearchResult]()
    let log = SwiftyBeaver.self
    
    @IBOutlet var imageCollectionView: ImageCollectionView!
    
    //We use Notification Center to handle toggling the Sidebar
    @objc func appDataImagesChanged(notification: NSNotification) {

        //Fetch images
        self.imageSearchResults = AppData.shared.allImageResults
        
        DispatchQueue.main.async {
            self.imageCollectionView.reloadData()
        }
    }
    
    func selectedImages() -> [ImageSearchResult] {
        var imageArray = [ImageSearchResult]()
        
        for indexPath in imageCollectionView.selectionIndexPaths {
            if let image = AppData.shared.imageAt(withIndexPath: indexPath) {
                imageArray.append(image)
            }
        }
        
        return imageArray
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(appDataImagesChanged(notification:)), name: .appDataImagesChanged, object: nil)
        
        // Do any additional setup after loading the view.
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        let image = NSImage(named: NSImage.Name("placeholderContent"))
        self.view.layer!.contents = image
    }
    
    override func viewDidAppear() {
        
        if(UserDefaults.standard.getAPIKey().isEmpty){
            self.performSegue(withIdentifier: NSStoryboardSegue.Identifier.init(rawValue: "configurationRequiredSegue"), sender: self)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func Refresh(results : [ImageSearchResult]){
        self.imageSearchResults = results
    }

    
    // MARK: NSCollectionView DataSource Protocol
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
            return AppData.shared.allImageResults.count
    }
    
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = imageCollectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ImageCollectionViewItem"), for: indexPath)
        
        guard let collectionViewItem = item as? ImageCollectionViewItem else {return item}

        let imageResult = AppData.shared.imageAt(withIndexPath: indexPath)
        collectionViewItem.setData(result: imageResult!)
        return item
    }
  
    //MARK: NSCollectionView Delegate
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        log.info("Selected \(collectionView.selectionIndexes.count) Items")

        AppData.shared.selectedIndexPaths = Array(collectionView.selectionIndexPaths)
        delegate?.updateSelected(items: Array(collectionView.selectionIndexPaths))

    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        
        log.info("Selected \(collectionView.selectionIndexes.count) Items")
        
        AppData.shared.selectedIndexPaths = Array(collectionView.selectionIndexPaths)
        delegate?.updateSelected(items: Array(collectionView.selectionIndexPaths))
    }
    
}

