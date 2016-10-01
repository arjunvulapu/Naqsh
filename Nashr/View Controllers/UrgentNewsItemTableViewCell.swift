//
//  UrgentNewsItemTableViewCell.swift
//  Nashr
//
//  Created by Amit Kulkarni on 27/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit

class UrgentNewsItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelChannelTitle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewFeed: UIImageView!
    @IBOutlet weak var labelUrgent: UILabel!
    
    @IBOutlet weak var imageViewVideo: UIImageView!
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var buttonShare: UIButton!
    
    var showAction:(()->Void)?
    var selectChannel:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewContainer.backgroundColor = UIColor.whiteColor()
        //self.viewContainer.layer.cornerRadius = 5
        
        //self.imageViewIcon.layer.cornerRadius = 5
        self.imageViewIcon.clipsToBounds = true
        self.imageViewVideo.hidden = true
        self.imageViewFeed.clipsToBounds = true
        
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        
        self.labelUrgent.alpha = 0
        self.labelChannelTitle.textAlignment = .Right
        self.labelDateTime.textAlignment = .Right
        
        self.labelUrgent.text = Localization.get("urgent")
        self.labelUrgent.font = nil
        self.labelUrgent.font = UIFont(name: "HelveticaNeueLTArabic-Bold", size: 15)
        self.labelUrgent.clipsToBounds = true
        
        self.labelTitle.font = nil
        self.labelTitle.font = UIFont(name: "HelveticaNeueLTArabic-Bold", size: CGFloat(Settings.titleFont))
        self.labelTitle.clipsToBounds = true
        
        self.labelChannelTitle.font = nil
        self.labelChannelTitle.font = UIFont(name: "HelveticaNeueLTArabic-Bold", size: 18)
        self.labelChannelTitle.clipsToBounds = true
        
        self.labelDateTime.font = nil
        self.labelDateTime.font = UIFont(name: "HelveticaNeueLTArabic-Bold", size: 16)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func showFeed(feed:Feed) {
        self.labelTitle.text = feed.Title
        //self.labelChannelTitle.text = feed.chanel.Title
        self.labelChannelTitle.attributedText = NSAttributedString(string: feed.chanel.Title)
        
//        if feed.now.characters.count > 0 {
//            //            let formatter = NSDateFormatter()
//            //            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            //            let date2 = formatter.dateFromString(feed.now)
//            //
//            let date = NSDate().dateByAddingTimeInterval(-Double(feed.times))
//            //let date = formatter.dateFromString(feed.now)
//            self.labelDateTime.text = date.timeAgo()
//        } else {
//            self.labelDateTime.text = ""
//        }
        
        self.labelDateTime.text = feed.Time
        
        if let imageURL = NSURL(string:feed.chanel.image) {
            self.imageViewIcon.setImageWithURL(imageURL)
        }
        
        if feed.image.characters.count == 0 {
            self.imageViewFeed.hidden = true
        } else {
            if let imageURL = NSURL(string:feed.image) {
                self.imageViewFeed.hidden = false
                self.imageViewFeed.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "Loading.png"), completed: { (image, error, cacheType, url) in
                    
                    
                })
            }
        }
        
        if feed.isUrgent == 1 {
            self.labelUrgent.alpha = 1
        } else {
            self.labelUrgent.alpha = 0
        }
    }
    
    @IBAction func channelSelectionTapped(sender: AnyObject) {
        self.selectChannel?()
    }
    
    @IBAction func actionButtonTapped(sender: AnyObject) {
        self.showAction?()
    }

}
