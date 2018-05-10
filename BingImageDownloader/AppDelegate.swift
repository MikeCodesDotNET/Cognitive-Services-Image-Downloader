//
//  AppDelegate.swift
//  BingImageDownloader
//
//  Created by Michael James on 17/04/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Cocoa
import SwiftyBeaver

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let log = SwiftyBeaver.self

    
    @IBAction func deleteMenuItemClicked(_ sender: NSMenuItem) {
        
    }

    
    @IBAction func deleteAllMenuItemClicked(_ sender: NSMenuItem) {
        AppData.shared.clearAll()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        setupLogging()
        setupUserDefaults()
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
    
    func setupLogging()
    {
        // add log destinations. at least one is needed!
        let console = ConsoleDestination()  // log to Xcode Console
        let file = FileDestination()  // log to default swiftybeaver.log file
        let cloud = SBPlatformDestination(appID: "Gw3GBb", appSecret: "cLjecdl2pfuisvbnAZaypuuOsvctqvid", encryptionKey: "52gajI0ii9bfx4vrhte6xpanpx16dARy") // to cloud
        
        cloud.minLevel = SwiftyBeaver.Level.verbose
        
        // use custom format and set console output to short time, log level & message
        console.format = "$DHH:mm:ss$d $L $M"
        // or use this for JSON output: console.format = "$J"
        
        // add the destinations to SwiftyBeaver
        log.addDestination(console)
        log.addDestination(file)
        log.addDestination(cloud)

    }


    // MARK - Menu
    @IBAction func ToggleInfo(_ sender: Any) {
        NotificationCenter.default.post(name: .toggleSideBar, object: nil)
    }
    
    
}

