//
//  UserDefaultsPreferencesViewController.swift
//  BingImageDownloader
//
//  Created by Michael James on 18/04/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Foundation
import AppKit

public class UserDefaultsPreferencesViewController : NSViewController {
    
    //MARK: - Outlets
    @IBOutlet var imageDownloadCount: NSTextField!
    @IBOutlet var imageType: NSComboBox!
    @IBOutlet var tags: NSTokenField!
    @IBOutlet var directoryPath: NSTextField!
    
    @IBAction func pickDirectoryClicked(_ sender: NSButton) {
        selectDownloadDirectory()
    }
    
    @IBAction func saveClicked(_ sender: NSButton) {
        SaveAndClose()
    }
    
    @IBAction func cancelClicked(_ sender: NSButton) {
         AttemptCancel()
    }
    
    //MARK: - Overrides
    override public func viewDidLoad() {
        directoryPath.stringValue = UserDefaults.standard.getDefaultOutputDirectory()
        imageDownloadCount.integerValue = UserDefaults.standard.getImageDownloadCount()
    }
    
    //Mark: - Funtions
    func selectDownloadDirectory()
    {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = true
        
        let i = panel.runModal()
        if(i == NSApplication.ModalResponse.OK){
            directoryPath.stringValue = (panel.url?.path)!
        }
    }
    
    func SaveAndClose()
    {
        //Update the UserDefaults values for persisting across launches
        UserDefaults.standard.setDefaultOutputDirectory(value: directoryPath.stringValue)
        UserDefaults.standard.setImageDownloadCount(value: imageDownloadCount.integerValue)
        UserDefaults.standard.setHasChangedSettings(value: true)
        
        
        self.view.window?.close()
    }
    
    func AttemptCancel()
    {
        //We want to make sure we don't have any 'dirty' values that we might be discarding.
        self.view.window?.close()
    }
    
}
