//
//  DetailsShareTableViewCell.swift
//  Nashr
//
//  Created by Amit Kulkarni on 03/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit

class DetailsShareTableViewCell: UITableViewCell {

    var showMoreDetails:(()->Void)?
    var showEmailOption:(()->Void)?
    var showInstagramOption:(()->Void)?
    var showFacebookOption:(()->Void)?
    var showTwitterOption:(()->Void)?
    var showWhatsappOption:(()->Void)?
    
    
    @IBOutlet weak var buttonMore: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.buttonMore.setTitle(Localization.get("click here for more details"), forState: .Normal)
        self.buttonMore.backgroundColor = UIColor(red:0.902,  green:0.902,  blue:0.902, alpha:1)
        self.buttonMore.layer.cornerRadius = 10
        self.buttonMore.layer.borderColor = UIColor(red:0.616,  green:0.616,  blue:0.616, alpha:1).CGColor
        self.buttonMore.layer.borderWidth = 1
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func buttonTapped(sender: AnyObject) {
        self.showMoreDetails?()
    }
    
    @IBAction func email(sender: AnyObject) {
        self.showEmailOption?()
    }
    
    @IBAction func instagram(sender: AnyObject) {
        self.showInstagramOption?()
    }
    
    @IBAction func facebook(sender: AnyObject) {
        self.showFacebookOption?()
    }
    
    @IBAction func twitter(sender: AnyObject) {
        self.showTwitterOption?()
    }
    
    @IBAction func whatsapp(sender: AnyObject) {
        self.showWhatsappOption?()
    }
}
