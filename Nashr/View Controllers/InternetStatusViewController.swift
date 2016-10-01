//
//  InternetStatusViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 16/09/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit

class InternetStatusViewController: BaseViewController {

    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonOK: UIButton!
    var delegate:PopupCloseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Settings.wordsDownloaded {
            self.labelTitle.text = Localization.get("title_offline")
            self.labelMessage.text = Localization.get("message_offline")
            self.buttonOK.setTitle(Localization.get("check_again"), forState: .Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func checkInternet(sender: AnyObject) {
        if Utils.isInternetAvailable() {
            (UIApplication.sharedApplication().delegate as! AppDelegate).reloadUI()
        }
    }
    
    @IBAction func checkStatus(sender: AnyObject) {
        if Utils.isInternetAvailable() {
            self.delegate?.closePopup(self)
        }
    }
}
