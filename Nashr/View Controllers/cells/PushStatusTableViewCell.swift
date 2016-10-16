//
//  PushStatusTableViewCell.swift
//  Nashr
//
//  Created by Amit Kulkarni on 17/10/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import Alamofire

class PushStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var option: UISwitch!
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.labelTitle.text = Localization.get("urgent_news_notification")
        self.option.on = (Settings.urgentNewsNotification == nil) ? true : Settings.urgentNewsNotification!
    }
    
    @IBAction func optionChanged(sender: AnyObject) {
        if Settings.deviceToken == nil {
            return
        }
        
        Settings.urgentNewsNotification = self.option.on
        Alamofire
            .request(.POST, Api.getUrl(Page.tokenRegister), parameters: ["device_token":Settings.deviceToken!, "status": (self.option.on == true) ? "true" : "false"])
            .responseJSON(completionHandler: { (response) in
                print ("registered")
            })
    }
}
