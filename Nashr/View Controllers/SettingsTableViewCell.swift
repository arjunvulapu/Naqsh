//
//  SettingsTableViewCell.swift
//  Nashr
//
//  Created by Amit Kulkarni on 18/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.labelTitle.textAlignment = .Right
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
