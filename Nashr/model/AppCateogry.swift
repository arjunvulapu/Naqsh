//
//	AppCateogry.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class AppCateogry{

	var chanels : [Chanel]!
	var id : String!
	var image : String!
	var title : String!
	var titleAr : String!
	var titleFr : String!


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

    
	init(fromDictionary dictionary: NSDictionary){
		chanels = [Chanel]()
		if let chanelsArray = dictionary["chanels"] as? [NSDictionary]{
			for dic in chanelsArray{
				let value = Chanel(fromDictionary: dic)
				chanels.append(value)
			}
		}
		id = dictionary["id"] as? String
		image = dictionary["image"] as? String
		title = dictionary["title"] as? String
		titleAr = dictionary["title_ar"] as? String
		titleFr = dictionary["title_fr"] as? String
	}

}