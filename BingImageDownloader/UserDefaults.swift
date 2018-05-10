//
//  Settings.swift
//  BingImageDownloader
//
//  Created by Michael James on 18/04/2018.
//  Copyright © 2018 Mike James. All rights reserved.
//

import Foundation

extension UserDefaults{
    
    enum UserDefaultsKeys : String {
        case hasChangedSettings
        case isOverwriteFileNameEnabled
        case defaultOutputDirectory
        case imageDownloadCount
        case apiKey
    }
    
    //MARK: API Key
    func setAPIKeys(value: String) {
        set(value, forKey: UserDefaultsKeys.apiKey.rawValue)
        synchronize()
    }
    
    func getAPIKey()-> String {
        let apiKey = string(forKey: UserDefaultsKeys.apiKey.rawValue)
        return apiKey ?? ""
    }
    
    //MARK: User Has Changed Default Settings
    func setHasChangedSettings(value: Bool) {
        set(value, forKey: UserDefaultsKeys.hasChangedSettings.rawValue)
        synchronize()
    }
    
    func getHasChangedSettings()-> Bool {
        return bool(forKey: UserDefaultsKeys.hasChangedSettings.rawValue)
    }
    
    //MARK: DefaultOutputDirectory
    func setDefaultOutputDirectory(value: String) {
        set(value, forKey: UserDefaultsKeys.defaultOutputDirectory.rawValue)
        synchronize()
    }
    
    func getDefaultOutputDirectory()-> String {
        return string(forKey: UserDefaultsKeys.defaultOutputDirectory.rawValue)!
    }
    
    //MARK: Enable Filename overwrite
    func setOverwriteFileName(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isOverwriteFileNameEnabled.rawValue)
        synchronize()
    }
    
    func isOverwriteFileNameEnabled()-> Bool {
        return bool(forKey: UserDefaultsKeys.isOverwriteFileNameEnabled.rawValue)
    }
    
    
    //MARK: Image Download Count
    func setImageDownloadCount(value: Int) {
        set(value, forKey: UserDefaultsKeys.imageDownloadCount.rawValue)
        synchronize()
    }
    
    func getImageDownloadCount()-> Int {
        return integer(forKey: UserDefaultsKeys.imageDownloadCount.rawValue)
    }
}
