//
//  ConfigurationRequiredViewController.swift
//  BingImageDownloader
//
//  Created by Michael James on 06/05/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Cocoa
import CoreGraphics
import SwiftyBeaver
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

public class ConfigurationRequiredViewController : NSViewController {
    
    private let log = SwiftyBeaver.self
    
    @IBOutlet var apiKeyTextField: NSSecureTextField!
    @IBOutlet var validateAndSaveButton: NSButton!

    @IBAction func requestedHelpClicked(_ sender: NSButton) { openDocumentationInWebBrowser() }
    @IBAction func getApiKeyClicked(_ sender: NSButton) { openApiRequestInWebBrowser() }
    @IBAction func validateAndSavedClicked(_ sender: NSButton) { validateApiKey() }
    
    func openDocumentationInWebBrowser(){
        if let url = URL(string: "https://azure.microsoft.com/en-us/services/cognitive-services/bing-image-search-api/"), NSWorkspace.shared.open(url) {
            MSAnalytics.trackEvent("Sent user to Custom Bing Search documentation")
        }
    }
    
    func openApiRequestInWebBrowser(){
        if let url = URL(string: "https://azure.microsoft.com/en-us/try/cognitive-services/?api=search-api-v7"), NSWorkspace.shared.open(url) {
            MSAnalytics.trackEvent("User Requested API Key")
        }
    }
    
    func validateApiKey()
    {
        if(apiKeyTextField.stringValue.isEmpty){
            shakeWindow()
            return
        }
        
        let imgDownloader = BingImageSearch(apiKey: apiKeyTextField.stringValue)
        imgDownloader.searchForImageTerm(searchTerm: "Validating", completion: processResult)
        
    }
    
    func processResult(result: [ImageSearchResult])
    {
        DispatchQueue.main.async {
            if(result.count > 0){
                UserDefaults.standard.setAPIKeys(value: self.apiKeyTextField.stringValue)
                self.dismiss(nil)
            }else{
                    self.shakeWindow()
                    self.log.info("User attempted validation of invalid API Key")
            }
        }
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
    
    func shakeWindow(){
       
        let window = self.view.window
        
        let numberOfShakes = 3
        let durationOfShake = 0.4
        let vigourOfShake : CGFloat = 0.03
        let frame : CGRect = (window?.frame)!
        let shakeAnimation :CAKeyframeAnimation  = CAKeyframeAnimation()
        
        let shakePath = CGMutablePath()
        shakePath.move( to: CGPoint(x:NSMinX(frame), y:NSMinY(frame)))
        
        for _ in 0...numberOfShakes-1 {
            shakePath.addLine(to: CGPoint(x:NSMinX(frame) - frame.size.width * vigourOfShake, y:NSMinY(frame)))
            shakePath.addLine(to: CGPoint(x:NSMinX(frame) + frame.size.width * vigourOfShake, y:NSMinY(frame)))
        }
        
        shakePath.closeSubpath()
        shakeAnimation.path = shakePath
        shakeAnimation.duration = durationOfShake
        
        let animations = [NSAnimatablePropertyKey(rawValue: "frameOrigin") : shakeAnimation]

        window?.animations = animations
        window?.animator().setFrameOrigin(NSPoint(x: frame.minX, y: frame.minY))
    }
    
}
