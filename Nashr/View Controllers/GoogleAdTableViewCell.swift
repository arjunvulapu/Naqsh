//
//  GoogleAdTableViewCell.swift
//  Nashr
//
//  Created by Balakrishna Nadella on 02/12/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import GoogleMobileAds
class GoogleAdTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    var showAction:(()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.containerView.backgroundColor = UIColor.whiteColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func shareNews(sender: AnyObject) {
        self.showAction?()
    }
}
