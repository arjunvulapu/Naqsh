//
//  MatchesTableViewCell.swift
//  Naqsh
//
//  Created by apple on 08/03/17.
//  Copyright © 2017 Amit Kulkarni. All rights reserved.
//

import UIKit
import SVProgressHUD
class MatchesTableViewCell: UITableViewCell {

    @IBOutlet weak var cricketBtn: UIButton!
    @IBOutlet weak var footbalBtn: UIButton!
    @IBOutlet weak var webView: UIWebView!
    var selectFootBal:(() -> Void)?
    var selectCricket:(() -> Void)?

    @IBAction func footbalBtnAction(sender: AnyObject) {
        self.selectFootBal?()
    }
    @IBAction func cricketBtnAction(sender: AnyObject) {
        self.selectCricket?()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        footbalBtn.setTitle(Localization.get("FootBall"), forState: .Normal)
        cricketBtn.setTitle(Localization.get("BasketBall"), forState: .Normal)
   

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   }
