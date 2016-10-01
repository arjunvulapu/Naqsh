//
//  CategoryTableViewCell.swift
//  Nashr
//
//  Created by Amit Kulkarni on 31/07/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewCategory: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
