//
//  AppSettings.swift
//  OnItsWay
//
//  Created by Amit Kulkarni on 14/07/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import Foundation

class Settings {
    enum Keys:String {
        case loginStatus = "LOGIN_STATUS"
        case languageSelected = "LANGUAGE_SELECTED"
        case memberId = "MEMBER_ID"
        case currentLangugae = "CURRENT_LANGUAGE"
        case memberName = "MEMBER_NAME"
        case fontSize = "FONT_SIZE"
        case fontStyle = "FONT_STYLE"
        case titleFontSize = "TITLE_FONT_STYLE"
        case wordsDownloaded = "WORDS_DOWNLOADED"
        case lastSloseTime = "LAST_CLOSE_TIME"
        case deviceToken = "DEVICE_TOKEN"
        case urgentNewsNotification = "URGENT_NEWS_NOTIFICATION"
    }
    
    static var urgentNewsNotification:Bool? {
        set(value) {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(value!, forKey:Keys.urgentNewsNotification.rawValue)
            defaults.synchronize()
        }
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.boolForKey(Keys.urgentNewsNotification.rawValue)
        }
    }
    
    static var deviceToken:String? {
        set(value) {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(value, forKey: Keys.deviceToken.rawValue)
            defaults.synchronize()
        }
        
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.valueForKey(Keys.deviceToken.rawValue) as? String
        }
    }
    
    static var lastClosetime:NSDate? {
        set(value) {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(value, forKey: Keys.lastSloseTime.rawValue)
            defaults.synchronize()
        }
        
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            return defaults.valueForKey(Keys.lastSloseTime.rawValue) as? NSDate
        }
    }
    
    static var currentFont:(size:Int, style:String) {
        set(values) {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(values.size, forKey: Keys.fontSize.rawValue)
            defaults.setValue(values.style, forKey: Keys.fontStyle.rawValue)
            defaults.synchronize()
        }
        
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            if !defaults.dictionaryRepresentation().keys.contains(Keys.fontSize.rawValue) {
                defaults.setInteger(20, forKey: Keys.fontSize.rawValue)
                defaults.setValue("normal", forKey: Keys.fontStyle.rawValue)
                defaults.synchronize()
            }
            
            return (defaults.integerForKey(Keys.fontSize.rawValue), defaults.valueForKey(Keys.fontStyle.rawValue) as! String)
        }
    }
    
    static var titleFont:(Int) {
        set(value) {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(value, forKey: Keys.titleFontSize.rawValue)
            defaults.synchronize()
        }
        
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            if !defaults.dictionaryRepresentation().keys.contains(Keys.titleFontSize.rawValue) {
                defaults.setInteger(20, forKey: Keys.titleFontSize.rawValue)
                defaults.synchronize()
            }
            
            return defaults.integerForKey(Keys.titleFontSize.rawValue)
        }
    }

    static var wordsDownloaded:Bool {
        set (status){
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(status, forKey: Keys.wordsDownloaded.rawValue)
            defaults.synchronize()
        }
        
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(Keys.wordsDownloaded.rawValue)
        }
    }
    
    static var languageSelected:Bool {
        set (status){
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(status, forKey: Keys.languageSelected.rawValue)
            defaults.synchronize()
        }
        
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(Keys.languageSelected.rawValue)
        }
    }
    
    static func currentUser() -> (id:Int, name:String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        return (id:defaults.integerForKey(Keys.memberId.rawValue), name:defaults.valueForKey(Keys.memberName.rawValue) as! String)
    }
    
    static func login(id:Int, name:String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(id, forKey: Keys.memberId.rawValue)
        defaults.setBool(true, forKey: Keys.loginStatus.rawValue)
        defaults.setValue(name, forKey: Keys.memberName.rawValue)
        defaults.synchronize()
    }
    
    static func isUserLoggedIn() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(Keys.loginStatus.rawValue)
    }
}
