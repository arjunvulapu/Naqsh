//
//  ChannelCollectionViewCell.swift
//  Nashr
//
//  Created by Amit Kulkarni on 03/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit

class ChannelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewChannel: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonADd: UIButton!

    var channelToggledCompleted:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.buttonADd.layer.borderColor = theme_color.CGColor
        self.buttonADd.layer.borderWidth = 1
    }
    
    
    @IBAction func toggleChannel(sender: AnyObject) {
        self.channelToggledCompleted?()
    }
}
