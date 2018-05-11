//
//  ExportSidebarViewController.swift
//  BingImageDownloader
//
//  Created by Michael James on 06/05/2018.
//  Copyright © 2018 Mike JAmes. All rights reserved.
//

import Cocoa

public class ExportSlidebarViewController : NSViewController {
    
    // MARK: Outlets
    @IBOutlet var selectedImagesLabel: NSTextField!
    @IBOutlet var outputDirectoryTextField: NSTextField!
    @IBOutlet var tagsTokenField: NSTokenField!
    @IBAction func setOutputDirectoryButtonClicked(_ sender: NSButton){selectOutputDirectory()}
    @IBAction func exportButtonClicked(_ sender: NSButton) { startDownload()
    }
    
    // MARK: View Life Cycle
    override public func viewDidLoad() {
        //outputDirectoryTextField.stringValue = UserDefaults.standard.getDefaultOutputDirectory()
    }
    
    func updateSelected(items : [IndexPath]){
        guard let count = AppData.shared.selectedIndexPaths?.count else {
            return
        }
        selectedImagesLabel.stringValue = "\(count) Images Selected"
     }
    
    // MARK: Helpers
    func selectOutputDirectory()
    {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = true
        
        let i = panel.runModal()
        if(i == NSApplication.ModalResponse.OK){
            outputDirectoryTextField.stringValue = (panel.url?.path)!
        }
    }
    
    private func startDownload()
    {
        AppData.shared.exportSelectedImages()
    }
}
