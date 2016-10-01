//
//	Chanel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Chanel : NSObject, NSCoding{

	var count : Int!
	var coverImage : String!
	var id : String!
	var image : String!
	var title : String!
	var titleAr : String!
	var titleFr : String!

    var selected = false
    
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
		count = dictionary["count"] as? Int
		coverImage = dictionary["cover_image"] as? String
		id = dictionary["id"] as? String
		image = dictionary["image"] as? String
		title = dictionary["title"] as? String
		titleAr = dictionary["title_ar"] as? String
		titleFr = dictionary["title_fr"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if count != nil{
			dictionary["count"] = count
		}
		if coverImage != nil{
			dictionary["cover_image"] = coverImage
		}
		if id != nil{
			dictionary["id"] = id
		}
		if image != nil{
			dictionary["image"] = image
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
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         count = aDecoder.decodeObjectForKey("count") as? Int
         coverImage = aDecoder.decodeObjectForKey("cover_image") as? String
         id = aDecoder.decodeObjectForKey("id") as? String
         image = aDecoder.decodeObjectForKey("image") as? String
         title = aDecoder.decodeObjectForKey("title") as? String
         titleAr = aDecoder.decodeObjectForKey("title_ar") as? String
         titleFr = aDecoder.decodeObjectForKey("title_fr") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if count != nil{
			aCoder.encodeObject(count, forKey: "count")
		}
		if coverImage != nil{
			aCoder.encodeObject(coverImage, forKey: "cover_image")
		}
		if id != nil{
			aCoder.encodeObject(id, forKey: "id")
		}
		if image != nil{
			aCoder.encodeObject(image, forKey: "image")
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

	}

}