//
//  NewsItemTableViewCell.swift
//  Nashr
//
//  Created by User on 19/07/16.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit
//import NSDate_TimeAgo
import MapleBacon
import SDWebImage
import KIImagePager


class NewsItemTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCount: UILabel?
    @IBOutlet weak var imageViewCount: UIImageView?
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
        self.labelCount?.isHidden = true
        self.imageViewCount?.isHidden = true
        
        self.viewContainer.backgroundColor = UIColor.white
        //self.viewContainer.layer.cornerRadius = 5
        
        self.imageViewIcon.layer.cornerRadius = self.imageViewIcon.frame.size.width/2
        self.imageViewIcon?.clipsToBounds = true
        self.imageViewVideo?.isHidden = true
        self.imageViewFeed?.clipsToBounds = true
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        
        self.labelUrgent.alpha = 0
        self.labelChannelTitle.textAlignment = .right
        if self.labelFullDate != nil {
            self.labelFullDate.textAlignment = .right
        }
        self.labelDateTime.textAlignment = .right
        
        self.imageViewFeed?.image = self.scaleImage(UIImage(named: "Loading.png")!, maximumWidth: 400)
        

        self.labelTitle.setColors()
        self.labelCount?.setColors()
        //self.labelUrgent.setColors()
        self.labelDateTime.setColors()
        //self.labelFullDate.setColors()
        self.labelChannelTitle.setColors()
        self.textLabel?.setColors()
        
        self.viewContainer.mixedBackgroundColor = MixedColor(normal: normal_background, night: night_container_background)
        self.mixedBackgroundColor = MixedColor(normal: normal_container_background, night: night_background)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func scaleImage(_ image: UIImage, maximumWidth: CGFloat) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let cgImage: CGImage = image.cgImage!.cropping(to: rect)!
        return UIImage(cgImage: cgImage, scale: image.size.height / 153, orientation: image.imageOrientation)
    }
    func convertToGrayScale(_ image: UIImage) -> UIImage {
        let imageRect:CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.draw(image.cgImage!, in: imageRect)
        let imageRef = context!.makeImage()
        let newImage = UIImage(cgImage: imageRef!)
        
        return newImage
    }
    func showFeed(_ feed:Feed,cat:NSString) {
        //self.labelTitle.attributedText = NSAttributedString(string:feed.Title
        
        if(cat .isEqual(to: "list"))
        {
            let defaults = UserDefaults.standard
            if let name = defaults.string(forKey: (feed.id)) {
                print(name)
                self.labelDateTime.textColor = UIColor.lightGray
                self.labelTitle.textColor = UIColor.lightGray
                
            }else{
                self.labelDateTime.mixedTextColor = MixedColor(normal: 0x000000, night: 0xffffff)
                self.labelTitle.mixedTextColor = MixedColor(normal: 0x000000, night: 0xffffff)
//                self.labelDateTime.mixedTextColor = MixedColor(normal: normal_background, night: night_background)
//
//                self.labelTitle.mixedTextColor = MixedColor(normal: normal_background, night: night_background)
//

            }
        }
 
        print(Utils.getDecodedString(feed.Title))
        self.labelTitle.text = Utils.getDecodedString(feed.Title)
        self.labelTitle.textAlignment = .right
        
        self.labelChannelTitle.text = Utils.getDecodedString(feed.chanel.Title)
        self.labelChannelTitle.textAlignment = .right
        
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
        self.labelDateTime.font = UIFont(name: "HelveticaNeueLTArabic-Bold", size: 14)
        self.labelDateTime.clipsToBounds = true

        self.labelDateTime.text = feed.Time
        if self.labelFullDate != nil {
            self.labelFullDate.text = feed.now
        }
        
        if let imageURL = URL(string:feed.chanel.image) {
            self.imageViewIcon.sd_setImage(with: imageURL)
        }
        
        print("image : \(feed.image)")
        
        let image = Utils.getDecodedString(feed.image)
        if (image.characters.count == 0) || (feed.titleOnly == true) {

            if self.imageViewFeed != nil {
                //self.videoHeight.constant = 0
                self.imageViewFeed?.isHidden = true
                var frame = self.imageViewFeed.frame
                frame.size.height = 0
                self.imageViewFeed.frame = frame
            }
            
            if self.imageViewVideo != nil {
                //self.imageHeight.constant = 0
                self.imageViewVideo?.isHidden = true
                var frame = self.imageViewVideo.frame
                frame.size.height = 0
                self.imageViewVideo.frame = frame
            }
            
            
        } else {
            if let imageURL = URL(string:image) {
                self.imageViewFeed?.isHidden = false
                self.imageViewFeed?.sd_setImage(with: imageURL,
                                                placeholderImage: UIImage(named: "Loading.png"),
                                                options: [],
                                                completed: { (image, error, cacheType, url) in
                                                    if image == nil {
                                                        
                                                        if self.imageViewFeed != nil {
                                                            //self.videoHeight.constant = 0
                                                            self.imageViewFeed?.isHidden = true
                                                            var frame = self.imageViewFeed.frame
                                                            frame.size.height = 0
                                                            self.imageViewFeed.frame = frame
                                                        }
                                                        
                                                        if self.imageViewVideo != nil {
                                                            //self.imageHeight.constant = 0
                                                            self.imageViewVideo?.isHidden = true
                                                            var frame = self.imageViewVideo.frame
                                                            frame.size.height = 0
                                                            self.imageViewVideo.frame = frame
                                                        }
                                                        
                                                    } else {
                                                        let defaults = UserDefaults.standard
                                                        if defaults.string(forKey: (feed.id)) != nil {
                                                            self.imageViewFeed?.image = self.scaleImage(self.convertToGrayScale(image!), maximumWidth: 400)
                                                            
                                                        }
                                                        else{
                                                            self.imageViewFeed?.image = self.scaleImage(image!, maximumWidth: 400)
                                                        }
                                                    }
                })
            }
        }
        
        if feed.titleOnly == false {
            if (feed.video != nil) && (!feed.video.isEmpty) {
                self.imageViewVideo?.isHidden = false
            } else if (feed.mp4 != nil) && (!feed.mp4.isEmpty) {
                self.imageViewVideo?.isHidden = false
            } else {
                self.imageViewVideo?.isHidden = true
            }
        } else {
            self.imageViewVideo?.isHidden = true
        }
        
        if feed.isUrgent == 1 {
            self.labelUrgent.alpha = 1
            self.labelDateTime.textAlignment = .right
        } else {
            self.labelUrgent.alpha = 0
            self.labelDateTime.textAlignment = .left
        }
    }
    
    @IBAction func channelSelectionTapped(_ sender: AnyObject) {
        self.selectChannel?()
    }
    
    @IBAction func actionButtonTapped(_ sender: AnyObject) {
        self.showAction?()
    }
    
    
}
