//
//  BugReportViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 18/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class BugReportViewController: BaseViewController {
    @IBOutlet weak var textMessage: UITextView!
    @IBOutlet weak var editName: JVFloatLabeledTextField!
    @IBOutlet weak var editEmail: JVFloatLabeledTextField!
    
    @IBOutlet weak var buttonSend: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editEmail.layer.borderWidth = 1
        self.editEmail.layer.cornerRadius = 5
        
        self.editName.layer.borderWidth = 1
        
        self.editName.layer.cornerRadius = 5
        
        self.textMessage.layer.borderWidth = 1
        self.textMessage.layer.cornerRadius = 5
        
        self.navigationItem.title = Localization.get("title_report_bug")
        self.editName.placeholder = Localization.get("name")
        self.editEmail.placeholder = Localization.get("email")
        self.textMessage.placeholderText = Localization.get("message")
        self.buttonSend.setTitle(Localization.get("send"), forState: .Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        if self.editName.text?.isEmpty == true {
            self.showErrorAlert("empty_name")
        } else if self.editEmail.text?.isEmpty == true {
            self.showErrorAlert("empty_email")
        } else if self.textMessage.text?.isEmpty == true {
            self.showErrorAlert("empty_message")
        } else {
            makeCall(Page.bugReport, params: ["name":self.editName.text!, "email":self.editEmail.text!, "message":self.textMessage.text!], completionHandler: { (response) in
                
                SweetAlert().showAlert("", subTitle: Localization.get("message_sent"), style: .Success, buttonTitle: Localization.get("ok"), action: { (isOtherButton) in
                    self.navigationController?.popViewControllerAnimated(true)
                })
                
            })
        }
    }
}
