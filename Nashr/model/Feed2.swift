//
//	Feed.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class Feed{

	var data : String!
	var id : String!
	var image : String!
	var title : String!
    var now : String!
    var chanel : Chanel!
    var isUrgent : Int!
    var link : String!
    var times:Int!
    var instaImg:String!
    var video:String!
    var time:String!
    var time_ar:String!
    var time_fr:String!
    
    var Title:String! {
        get {
            if Localization.currentLanguage() == Localization.Language.English {
                return self.title
            }
            /*else if Localization.currentLanguage() == Localization.Language.Arabic {
                return self.titleAr.characters.count > 0 ? self.titleAr : self.title
            } else if Localization.currentLanguage() == Localization.Language.French {
                return self.titleFr.characters.count > 0 ? self.titleFr : self.title
            }
             */
            
            return self.title
        }
    }
    
    var Time:String! {
        get {
            if Localization.currentLanguage() == Localization.Language.English {
                return self.time
            } else if Localization.currentLanguage() == Localization.Language.Arabic {
                return self.time_ar.characters.count > 0 ? self.time_ar : self.time
            } else if Localization.currentLanguage() == Localization.Language.French {
                return self.time_fr.characters.count > 0 ? self.time_fr : self.time
            }
            
            return self.time
        }
    }
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
        
        if let chanelData = dictionary["chanel"] as? NSDictionary{
            chanel = Chanel(fromDictionary: chanelData)
        }
        
        time = dictionary["time"] as? String
        time_ar = dictionary["time_ar"] as? String
        time_fr = dictionary["time_fr"] as? String
        
        video = dictionary["video"] as? String
        instaImg = dictionary["insta_img"] as? String
        times = dictionary["times"] as? Int
        link = dictionary["link"] as? String
        isUrgent = dictionary["is_urgent"] as? Int
		data = dictionary["data"] as? String
		id = dictionary["id"] as? String
		image = dictionary["image"] as? String
		title = dictionary["title"] as? String
        now = dictionary["now"] as? String
	}

}