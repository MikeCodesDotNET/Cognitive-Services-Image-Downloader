//
//  AppDelegate.swift
//  BingImageDownloader
//
//  Created by Michael James on 17/04/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Cocoa
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBAction func deleteMenuItemClicked(_ sender: NSMenuItem) {}
    
    @IBAction func deleteAllMenuItemClicked(_ sender: NSMenuItem) {
        let cleared = AppData.shared.clearAll()
        print(cleared)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        setupUserDefaults()
        MSAppCenter.start("892b4073-c8a2-4ee7-af52-fca3fffecba9", withServices: [MSCrashes.self, MSAnalytics.self])
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func setupUserDefaults()
    {
       let useHasChangedDefaults = UserDefaults.standard.getHasChangedSettings()
    
        if(!useHasChangedDefaults){
            
            //Default image directory for macOS
            let picturesDirectory = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!.path
            
            let newDirectoryPath = picturesDirectory + "/" + "Image Downloader"
            UserDefaults.standard.setDefaultOutputDirectory(value: newDirectoryPath)
            UserDefaults.standard.setImageDownloadCount(value: 50)
            UserDefaults.standard.setAPIKeys(value: "")
        }

    }
    
    // MARK - Menu
    @IBAction func ToggleInfo(_ sender: Any) {
        NotificationCenter.default.post(name: .toggleSideBar, object: nil)
    }
    
}

