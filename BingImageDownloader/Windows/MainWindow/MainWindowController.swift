//
//  MainWindowController.swift
//  BingImageDownloader
//
//  Created by Michael James on 17/04/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Foundation
import AppKit
import Quartz
import SwiftyBeaver
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

public class MainWindowController : NSWindowController, NSWindowDelegate,  imageSeletionDelegate {
    
    var quickLookActive = false
    let log = SwiftyBeaver.self
    
    
    var imageCollectionViewController : ImageCollectionViewController{
        get {
            let splitPanel = self.contentViewController as! NSSplitViewController
            return splitPanel.splitViewItems[0].viewController as! ImageCollectionViewController
        }
    }
    
    var exportSidebarViewController : ExportSlidebarViewController {
        get {
            let splitPanel = self.contentViewController as! NSSplitViewController
            return splitPanel.splitViewItems[1].viewController as! ExportSlidebarViewController
        }
    }
    
    // MARK: Outlets
    @IBOutlet var progressIndicator: NSProgressIndicator!
    @IBOutlet var searchField: NSSearchField!
    @IBOutlet var outputDirectoryTouchBarLabel: NSTextField!

    @IBAction func toggleInfoPanelClicked(_ sender: NSToolbarItem) {NotificationCenter.default.post(name: .toggleSideBar, object: nil)}
    @IBAction func searchTermChangedAction(_ sender: NSSearchField) {searchImages(searchTerm: sender.stringValue)}
    @IBAction func changeDirectoryTouchBarButtonClicked(_ sender: NSButton) {}
    
    // MARK: View Lifecycle
    public override func windowDidLoad() {
        
        //Setting up the touchbar guff
        outputDirectoryTouchBarLabel.stringValue = "Saving To: \(UserDefaults.standard.getDefaultOutputDirectory())"
        
        //Observing the info panel toggle
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideBar(notification:)), name: .toggleSideBar, object: nil)
        
        self.progressIndicator.isHidden = true
        self.progressIndicator.startAnimation(self)
    
        imageCollectionViewController.delegate = self
        
         self.performSegue(withIdentifier: NSStoryboardSegue.Identifier.init(rawValue: "configurationRequiredSegue"), sender: self)
    }


    
    // MARK: User Interaction & UI
    @objc func toggleSideBar(notification: NSNotification) {
        //I use Notification Center to notify subscribers that the user has toggled the Sidebar
        let splitViewController = self.contentViewController as! NSSplitViewController
        splitViewController.splitViewItems[1].animator().isCollapsed = !splitViewController.splitViewItems[1].animator().isCollapsed

    }
    
    func progressOn(_ progress: Bool) {
        DispatchQueue.main.async {
            if progress {
                self.progressIndicator.isHidden = !progress
            }
            else {
                self.progressIndicator.isHidden = !progress
            }
        }
    }
    
    // MARK: Helpers
    private func searchImages(searchTerm : String)
    {
        progressOn(true)
        //ImageDownloader is responsbile for connecting to Bing and downloading our images to disk
        let imageDownloader = BingImageSearch(apiKey: UserDefaults.standard.getAPIKey())
        
        //Ensure we're not searching with no text values
        if(!searchTerm.isEmpty){
            self.log.info("Searched for: \(searchTerm)")
            
            MSAnalytics.trackEvent("Searched", withProperties: ["Query" : searchTerm])
            imageDownloader.searchForImageTerm(searchTerm: searchTerm)
        }
        
    }
    
    
    //MARK : imageSeletion Delegate
    func updateSelected(items : [IndexPath])
    {
        exportSidebarViewController.updateSelected(items: items)
    }
    
    
    public func windowDidChangeOcclusionState(_ notification: Notification) {
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier.init(rawValue: "configurationRequiredSegue"), sender: self)

    }
    
    
}
