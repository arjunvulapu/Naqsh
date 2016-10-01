//
//	Feed.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Feed : NSObject, NSCoding{

	var chanel : Chanel!
	var data : String!
	var facebookStr : String!
	var gallery : [AnyObject]!
	var id : String!
	var image : String!
	var instaImg : String!
	var isUrgent : Int!
	var link : String!
	var mailStr : String!
	var now : String!
	var time : String!
	var timeAr : String!
	var timeFr : String!
	var times : Int!
	var times2 : String!
	var title : String!
	var twitterStr : String!
	var video : String!
	var whatsappStr : String!

    var Time:String! {
        get {
            if Localization.currentLanguage() == Localization.Language.English {
                return self.time
            } else if Localization.currentLanguage() == Localization.Language.Arabic {
                return self.timeAr.characters.count > 0 ? self.timeAr : self.time
            } else if Localization.currentLanguage() == Localization.Language.French {
                return self.timeFr.characters.count > 0 ? self.timeFr : self.time
            }
            
            return self.time
        }
    }
    
    var Title:String! {
        get {
//            if Localization.currentLanguage() == Localization.Language.English {
//                return self.title
//            } else if Localization.currentLanguage() == Localization.Language.Arabic {
//                return self.titleAr.characters.count > 0 ? self.titleAr : self.title
//            } else if Localization.currentLanguage() == Localization.Language.French {
//                return self.titleFr.characters.count > 0 ? self.titleFr : self.title
//            }            
            return self.title
        }
    }
    

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		if let chanelData = dictionary["chanel"] as? NSDictionary{
			chanel = Chanel(fromDictionary: chanelData)
		}
		data = dictionary["data"] as? String
		facebookStr = dictionary["facebook_str"] as? String
		gallery = dictionary["gallery"] as? [AnyObject]
		id = dictionary["id"] as? String
		image = dictionary["image"] as? String
		instaImg = dictionary["insta_img"] as? String
		isUrgent = dictionary["is_urgent"] as? Int
		link = dictionary["link"] as? String
		mailStr = dictionary["mail_str"] as? String
		now = dictionary["now"] as? String
		time = dictionary["time"] as? String
		timeAr = dictionary["time_ar"] as? String
		timeFr = dictionary["time_fr"] as? String
		times = dictionary["times"] as? Int
		times2 = dictionary["times2"] as? String
		title = dictionary["title"] as? String
		twitterStr = dictionary["twitter_str"] as? String
		video = dictionary["video"] as? String
		whatsappStr = dictionary["whatsapp_str"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if chanel != nil{
			dictionary["chanel"] = chanel.toDictionary()
		}
		if data != nil{
			dictionary["data"] = data
		}
		if facebookStr != nil{
			dictionary["facebook_str"] = facebookStr
		}
		if gallery != nil{
			dictionary["gallery"] = gallery
		}
		if id != nil{
			dictionary["id"] = id
		}
		if image != nil{
			dictionary["image"] = image
		}
		if instaImg != nil{
			dictionary["insta_img"] = instaImg
		}
		if isUrgent != nil{
			dictionary["is_urgent"] = isUrgent
		}
		if link != nil{
			dictionary["link"] = link
		}
		if mailStr != nil{
			dictionary["mail_str"] = mailStr
		}
		if now != nil{
			dictionary["now"] = now
		}
		if time != nil{
			dictionary["time"] = time
		}
		if timeAr != nil{
			dictionary["time_ar"] = timeAr
		}
		if timeFr != nil{
			dictionary["time_fr"] = timeFr
		}
		if times != nil{
			dictionary["times"] = times
		}
		if times2 != nil{
			dictionary["times2"] = times2
		}
		if title != nil{
			dictionary["title"] = title
		}
		if twitterStr != nil{
			dictionary["twitter_str"] = twitterStr
		}
		if video != nil{
			dictionary["video"] = video
		}
		if whatsappStr != nil{
			dictionary["whatsapp_str"] = whatsappStr
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         chanel = aDecoder.decodeObjectForKey("chanel") as? Chanel
         data = aDecoder.decodeObjectForKey("data") as? String
         facebookStr = aDecoder.decodeObjectForKey("facebook_str") as? String
         gallery = aDecoder.decodeObjectForKey("gallery") as? [AnyObject]
         id = aDecoder.decodeObjectForKey("id") as? String
         image = aDecoder.decodeObjectForKey("image") as? String
         instaImg = aDecoder.decodeObjectForKey("insta_img") as? String
         isUrgent = aDecoder.decodeObjectForKey("is_urgent") as? Int
         link = aDecoder.decodeObjectForKey("link") as? String
         mailStr = aDecoder.decodeObjectForKey("mail_str") as? String
         now = aDecoder.decodeObjectForKey("now") as? String
         time = aDecoder.decodeObjectForKey("time") as? String
         timeAr = aDecoder.decodeObjectForKey("time_ar") as? String
         timeFr = aDecoder.decodeObjectForKey("time_fr") as? String
         times = aDecoder.decodeObjectForKey("times") as? Int
         times2 = aDecoder.decodeObjectForKey("times2") as? String
         title = aDecoder.decodeObjectForKey("title") as? String
         twitterStr = aDecoder.decodeObjectForKey("twitter_str") as? String
         video = aDecoder.decodeObjectForKey("video") as? String
         whatsappStr = aDecoder.decodeObjectForKey("whatsapp_str") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if chanel != nil{
			aCoder.encodeObject(chanel, forKey: "chanel")
		}
		if data != nil{
			aCoder.encodeObject(data, forKey: "data")
		}
		if facebookStr != nil{
			aCoder.encodeObject(facebookStr, forKey: "facebook_str")
		}
		if gallery != nil{
			aCoder.encodeObject(gallery, forKey: "gallery")
		}
		if id != nil{
			aCoder.encodeObject(id, forKey: "id")
		}
		if image != nil{
			aCoder.encodeObject(image, forKey: "image")
		}
		if instaImg != nil{
			aCoder.encodeObject(instaImg, forKey: "insta_img")
		}
		if isUrgent != nil{
			aCoder.encodeObject(isUrgent, forKey: "is_urgent")
		}
		if link != nil{
			aCoder.encodeObject(link, forKey: "link")
		}
		if mailStr != nil{
			aCoder.encodeObject(mailStr, forKey: "mail_str")
		}
		if now != nil{
			aCoder.encodeObject(now, forKey: "now")
		}
		if time != nil{
			aCoder.encodeObject(time, forKey: "time")
		}
		if timeAr != nil{
			aCoder.encodeObject(timeAr, forKey: "time_ar")
		}
		if timeFr != nil{
			aCoder.encodeObject(timeFr, forKey: "time_fr")
		}
		if times != nil{
			aCoder.encodeObject(times, forKey: "times")
		}
		if times2 != nil{
			aCoder.encodeObject(times2, forKey: "times2")
		}
		if title != nil{
			aCoder.encodeObject(title, forKey: "title")
		}
		if twitterStr != nil{
			aCoder.encodeObject(twitterStr, forKey: "twitter_str")
		}
		if video != nil{
			aCoder.encodeObject(video, forKey: "video")
		}
		if whatsappStr != nil{
			aCoder.encodeObject(whatsappStr, forKey: "whatsapp_str")
		}

	}

}