//
//	TVLink.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class TVLink{

	var id : String!
	var image : String!
	var link : String!
	var title : String!
	var titleAr : String!
	var titleFr : String!
    var youtube: String!

    var Title:String! {
        get {
            if Localization.currentLanguage() == Localization.Language.English {
                return self.title
            } else if Localization.currentLanguage() == Localization.Language.Arabic {
                return self.titleAr.characters.count > 0 ? self.titleAr : self.title
            } else if Localization.currentLanguage() == Localization.Language.French {
                return self.titleFr.characters.count > 0 ? self.titleFr : self.title
            }
            
            return self.title
        }
    }
    
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		id = dictionary["id"] as? String
		image = dictionary["image"] as? String
		link = dictionary["link"] as? String
		title = dictionary["title"] as? String
		titleAr = dictionary["title_ar"] as? String
		titleFr = dictionary["title_fr"] as? String
        youtube = dictionary["youtube"] as? String
	}

}