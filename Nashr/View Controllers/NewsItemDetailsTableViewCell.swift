//
//  NewsItemDetailsTableViewCell.swift
//  Nashr
//
//  Created by Amit Kulkarni on 27/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import KIImagePager

class NewsItemDetailsTableViewCell: UITableViewCell, KIImagePagerDelegate, KIImagePagerDataSource {
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelChannelTitle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelUrgent: UILabel!
    @IBOutlet weak var imageViewVideo: UIImageView!
    
    @IBOutlet weak var labelDateTime: UILabel!
    @IBOutlet weak var labelFullDate: UILabel!
    
    @IBOutlet weak var pager: KIImagePager!
    var selectChannel:(() -> Void)?
    var imageSelected:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewContainer.backgroundColor = UIColor.whiteColor()
        self.imageViewIcon.clipsToBounds = true
        self.imageViewVideo.hidden = true
        //self.imageViewFeed.clipsToBounds = true
        
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        
        self.labelUrgent.alpha = 0
        self.labelChannelTitle.textAlignment = .Right
        self.labelFullDate.textAlignment = .Right
        
        self.labelChannelTitle.textAlignment = .Right
        self.labelFullDate.textAlignment = .Right
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
        self.labelDateTime.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var images:[String] = []
    func showFeed(feed:Feed) {
        
        self.labelTitle.text = feed.Title
        //self.labelChannelTitle.text = feed.chanel.Title
        self.labelChannelTitle.attributedText = NSAttributedString(string: feed.chanel.Title)

        self.labelDateTime.text = feed.Time
        self.labelFullDate.text = feed.now
        
        if let imageURL = NSURL(string:feed.chanel.image) {
            self.imageViewIcon.setImageWithURL(imageURL)
        }
        
        if feed.gallery.count == 0 {
            self.images.append(feed.image)
        } else {
            for image in feed.gallery {
                self.images.append(image as! String)
            }
        }
        
        self.pager.dataSource = self
        self.pager.delegate = self
        
        if feed.isUrgent == 1 {
            self.labelUrgent.alpha = 1
        } else {
            self.labelUrgent.alpha = 0
        }
    }
    
    func arrayWithImages(pager: KIImagePager!) -> [AnyObject]! {
        return self.images
    }
    
    func contentModeForImage(image: UInt, inPager pager: KIImagePager!) -> UIViewContentMode {
        return .ScaleAspectFill
    }
    
    func placeHolderImageForImagePager(pager: KIImagePager!) -> UIImage! {
        return UIImage(named: "Loading.png")
    }
    
    func contentModeForPlaceHolder(pager: KIImagePager!) -> UIViewContentMode {
        return .ScaleAspectFill
    }
    
    func imagePager(imagePager: KIImagePager!, didSelectImageAtIndex index: UInt) {
        self.imageSelected?()
    }
}
