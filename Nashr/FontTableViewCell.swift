//
//  SettingsTableViewCell.swift
//  Nashr
//
//  Created by User on 18/08/16.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var arrowLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.labelTitle.textAlignment = .Right
        self.labelTitle.setColors()
        self.arrowLbl.setColors()
        self.mixedBackgroundColor = MixedColor(normal: normal_background, night: night_background)
        self.labelTitle.font=UIFont(name:"HelveticaNeueLTArabic-Bold", size:16)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
