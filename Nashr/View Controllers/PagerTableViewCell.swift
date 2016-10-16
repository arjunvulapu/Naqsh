//
//  PagerTableViewCell.swift
//  Nashr
//
//  Created by Amit Kulkarni on 19/09/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import KIImagePager

class PagerTableViewCell: UITableViewCell, KIImagePagerDelegate, KIImagePagerDataSource {

    @IBOutlet weak var videoIcon: UIImageView!
    @IBOutlet weak var pager: KIImagePager!
    var imageSelected:(() -> Void)?
    var startVideo:(() -> Void)?
    
    @IBOutlet weak var buttonPlay: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buttonPlay.hidden = true
    }

    @IBAction func playVideo(sender: AnyObject) {
        self.startVideo?()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var images:[String]?
    func showImages(images:[String]) {
        self.images = images
        self.pager.dataSource = self
        self.pager.delegate = self
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
