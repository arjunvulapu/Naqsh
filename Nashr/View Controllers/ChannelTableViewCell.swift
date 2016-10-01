//
//  ChannelTableViewCell.swift
//  Nashr
//
//  Created by Amit Kulkarni on 31/07/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewChannel: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonADd: UIButton!
    
    var channelToggledCompleted:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.labelTitle.textAlignment = .Right
        self.buttonADd.layer.borderColor = theme_color.CGColor
        self.buttonADd.layer.borderWidth = 1
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func toggleChannel(sender: AnyObject) {
        self.channelToggledCompleted?()
    }
}
