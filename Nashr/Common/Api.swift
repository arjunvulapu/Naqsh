//
//  Constants.swift
//  OnItsWay
//
//  Created by Amit Kulkarni on 13/07/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import Foundation

enum Page: String {
    case words = "words-json.php"
    case feeds = "feeds.php"
    case categories = "categories.php"
    case tvLink = "tv-live.php"
    case selectedCategories = "channels.php"
    case settings = "settings.php"
    case suggestions = "suggestions.php"
    case bugReport = "bug_reports.php"
    case contactUs = "contact-us.php"
    case reportAbuse = "report_abuse.php"
    case tvLiveCategories = "tv-category.php"
    case tvLinkFull = "tv-full.php"
    case followChannel = "follow_cnt.php"
}

class Api {
    
    //static let BASE_URL = "http://3ajelapp.com/nashr/api/"
    static let BASE_URL = "http://nashrapp.com/api/"
    
    static func getUrl(page:Page) -> String {
        let str = String(format: "%@/%@", BASE_URL, page.rawValue)
        print ("url \(str)")
        return str
    }
}
