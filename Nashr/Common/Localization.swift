//
//  Localization.swift
//  OnItsWay
//
//  Created by Amit Kulkarni on 13/07/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import Foundation

class Localization {
    static let path = NSString.pathWithComponents([NSHomeDirectory(), "Documents", "strings.json"])
    
    enum Language:String {
        case English = "en", Arabic = "ar", French = "fr"
    }
    
    var currentLocale = Language.English
    
    static func currentLanguage() -> Language {
        return sharedInstance.currentLocale
    }
    
    static func isLanguageSet() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.boolForKey(Settings.Keys.languageSelected.rawValue)
    }
    
    static func changeLanguage(language:Language) {
        sharedInstance.currentLocale = language
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: Settings.Keys.languageSelected.rawValue)
        defaults.setValue(language.rawValue, forKey: Settings.Keys.currentLangugae.rawValue)
        defaults.setObject(["en"], forKey: "AppleLanguages")
        defaults.setObject(["en"], forKey: "NSLanguages")
        defaults.setValue("en", forKey: "AppleLocale")
        defaults.synchronize()
        
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.reloadUI()
    }
    
    let json:NSDictionary
    
    func get(word:String) -> String {
        let temp:NSDictionary = self.json.objectForKey(self.currentLocale.rawValue) as! NSDictionary
        return temp.valueForKey(word) as! String //self.json[self.currentLocale.rawValue][word].stringValue
    }
    
    static func get(word:String) -> String {
        return sharedInstance.get(word)
    }
    
    var words:[String:String] = [:]
    static let sharedInstance = Localization()
    
    private init() {
        let data = try! NSData(contentsOfURL: NSURL(fileURLWithPath: Localization.path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
        self.json = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSDictionary
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let lan = defaults.valueForKey(Settings.Keys.currentLangugae.rawValue) as? String {
            if lan == "en" {
                self.currentLocale = Language.English
            } else if lan == "ar" {
                self.currentLocale = Language.Arabic
            } else if lan == "fr" {
                self.currentLocale = Language.French
            }
            
        } else {
            self.currentLocale = Language.English
        }
    }
}