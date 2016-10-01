//
//	Tv.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Tv : NSObject, NSCoding{

	var id : String!
	var image : String!
	var link : String!
	var title : String!
	var titleAr : String!
	var titleFr : String!
	var youtube : String!

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

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if id != nil{
			dictionary["id"] = id
		}
		if image != nil{
			dictionary["image"] = image
		}
		if link != nil{
			dictionary["link"] = link
		}
		if title != nil{
			dictionary["title"] = title
		}
		if titleAr != nil{
			dictionary["title_ar"] = titleAr
		}
		if titleFr != nil{
			dictionary["title_fr"] = titleFr
		}
		if youtube != nil{
			dictionary["youtube"] = youtube
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObjectForKey("id") as? String
         image = aDecoder.decodeObjectForKey("image") as? String
         link = aDecoder.decodeObjectForKey("link") as? String
         title = aDecoder.decodeObjectForKey("title") as? String
         titleAr = aDecoder.decodeObjectForKey("title_ar") as? String
         titleFr = aDecoder.decodeObjectForKey("title_fr") as? String
         youtube = aDecoder.decodeObjectForKey("youtube") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encodeObject(id, forKey: "id")
		}
		if image != nil{
			aCoder.encodeObject(image, forKey: "image")
		}
		if link != nil{
			aCoder.encodeObject(link, forKey: "link")
		}
		if title != nil{
			aCoder.encodeObject(title, forKey: "title")
		}
		if titleAr != nil{
			aCoder.encodeObject(titleAr, forKey: "title_ar")
		}
		if titleFr != nil{
			aCoder.encodeObject(titleFr, forKey: "title_fr")
		}
		if youtube != nil{
			aCoder.encodeObject(youtube, forKey: "youtube")
		}

	}

}