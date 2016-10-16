//
//  NewsItemTableViewCell.swift
//  Nashr
//
//  Created by Amit Kulkarni on 19/07/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
//import NSDate_TimeAgo
import MapleBacon
import SDWebImage
import KIImagePager


class NewsItemTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewVideo: UIImageView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelChannelTitle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewFeed: UIImageView!
    @IBOutlet weak var labelUrgent: UILabel!
    
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var buttonShare: UIButton!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var videoHeight: NSLayoutConstraint!
    @IBOutlet weak var labelFullDate: UILabel!
    var images:[String] = []
    @IBOutlet weak var pager: KIImagePager!
    
    var imageSelected:(() -> Void)?
    var showAction:(()->Void)?
    var selectChannel:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewContainer.backgroundColor = UIColor.whiteColor()
        //self.viewContainer.layer.cornerRadius = 5
        
        //self.imageViewIcon.layer.cornerRadius = 5
        self.imageViewIcon?.clipsToBounds = true
        self.imageViewVideo?.hidden = true
        self.imageViewFeed?.clipsToBounds = true
        
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        
        
        self.labelUrgent.alpha = 0
        self.labelChannelTitle.textAlignment = .Right
        if self.labelFullDate != nil {
            self.labelFullDate.textAlignment = .Right
        }
        self.labelDateTime.textAlignment = .Right
        
        self.imageViewFeed?.image = self.scaleImage(UIImage(named: "Loading.png")!, maximumWidth: 400)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func scaleImage(image: UIImage, maximumWidth: CGFloat) -> UIImage {
        let rect: CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
        let cgImage: CGImageRef = CGImageCreateWithImageInRect(image.CGImage!, rect)!
        return UIImage(CGImage: cgImage, scale: image.size.height / 153, orientation: image.imageOrientation)
    }
    
    func showFeed(feed:Feed) {
        //self.labelTitle.attributedText = NSAttributedString(string:feed.Title)
        self.labelTitle.text = feed.Title
        self.labelTitle.textAlignment = .Right
        
        self.labelChannelTitle.text = feed.chanel.Title
        self.labelChannelTitle.textAlignment = .Right
        
        //self.labelChannelTitle.attributedText = NSAttributedString(string: feed.chanel.Title)

        self.labelTitle.font = nil
        self.labelTitle.font = UIFont(name: "HelveticaNeueLTArabic-Bold", size: CGFloat(Settings.titleFont))
        self.labelTitle.clipsToBounds = true
        
        self.labelUrgent.text = Localization.get("urgent")
        self.labelUrgent.font = nil
        self.labelUrgent.font = UIFont(name: "HelveticaNeueLTArabic-Bold", size: 15)
        self.labelUrgent.clipsToBounds = true
        
        self.labelChannelTitle.font = nil
        self.labelChannelTitle.font = UIFont(name: "HelveticaNeueLTArabic", size: 18)
        self.labelChannelTitle.clipsToBounds = true
        
        self.labelDateTime.font = nil
        self.labelDateTime.font = UIFont(name: "HelveticaNeueLTArabic", size: 14)
        self.labelDateTime.clipsToBounds = true

        self.labelDateTime.text = feed.Time
        if self.labelFullDate != nil {
            self.labelFullDate.text = feed.now
        }
        
        if let imageURL = NSURL(string:feed.chanel.image) {
            self.imageViewIcon.setImageWithURL(imageURL)
        }
        
        print("image : \(feed.image)")
        
        if feed.image.characters.count == 0 {

            if self.imageViewFeed != nil {
                //self.videoHeight.constant = 0
                self.imageViewFeed?.hidden = true
                var frame = self.imageViewFeed.frame
                frame.size.height = 0
                self.imageViewFeed.frame = frame
            }
            
            if self.imageViewVideo != nil {
                //self.imageHeight.constant = 0
                self.imageViewVideo?.hidden = true
                var frame = self.imageViewVideo.frame
                frame.size.height = 0
                self.imageViewVideo.frame = frame
            }
            
            
        } else {
            if let imageURL = NSURL(string:feed.image) {
                self.imageViewFeed?.hidden = false
                self.imageViewFeed?.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "Loading.png"), completed: { (image, error, cacheType, url) in
                    if image == nil {
                        
                        if self.imageViewFeed != nil {
                            //self.videoHeight.constant = 0
                            self.imageViewFeed?.hidden = true
                            var frame = self.imageViewFeed.frame
                            frame.size.height = 0
                            self.imageViewFeed.frame = frame
                        }

                        if self.imageViewVideo != nil {
                            //self.imageHeight.constant = 0
                            self.imageViewVideo?.hidden = true
                            var frame = self.imageViewVideo.frame
                            frame.size.height = 0
                            self.imageViewVideo.frame = frame
                        }

                    } else {
                        self.imageViewFeed?.image = self.scaleImage(image, maximumWidth: 400)
                    }
                })
            }
        }
        
        if !feed.video.isEmpty {
            self.imageViewVideo?.hidden = false
        } else {
            self.imageViewVideo?.hidden = true
        }
        
        if feed.isUrgent == 1 {
            self.labelUrgent.alpha = 1
            self.labelDateTime.textAlignment = .Right
        } else {
            self.labelUrgent.alpha = 0
            self.labelDateTime.textAlignment = .Left
        }
    }
    
    @IBAction func channelSelectionTapped(sender: AnyObject) {
        self.selectChannel?()
    }
    
    @IBAction func actionButtonTapped(sender: AnyObject) {
        self.showAction?()
    }
    
    
}
