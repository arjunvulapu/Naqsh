//
//  AppSettingsViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 07/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import Social
import MessageUI

class AppSettingsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    var dictionary:NSDictionary?
    
    @IBOutlet weak var talbeView: UITableView!
    
    
    let section1:[String] = [Localization.get("change_language"), Localization.get("urgent_news_notification"), Localization.get("sound_notifications"), Localization.get("size_font_address")]
    
    let section2:[String] = [Localization.get("contact_us"), Localization.get("facebook_nashrapp"), Localization.get("twitter_nashrapp"), Localization.get("instagram_nashrapp"), Localization.get("rate_nashrapp"), Localization.get("suggest_add_source"), Localization.get("report_bug")]
    let section2Icons:[String] = ["settings_contact_us.png", "settings_facebook.png", "settings_twitter.png", "settings_instagram.png", "settings_rate.png", "settings_suggest.png", "settings_warning.png"]
    
    
    let section3:[String] = [Localization.get("whatsapp"), Localization.get("facebook"), Localization.get("twitter"), Localization.get("Instagram"), Localization.get("google_plus"), Localization.get("linked_in"), Localization.get("email"), Localization.get("sms")]
    let section3Icons:[String] = ["settings_whatsapp.png", "settings_facebook.png", "settings_twitter.png", "settings_instagram.png", "settings_googleplus.png", "settings_linkedin.png", "settings_email.png", "settings_sms.png"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Localization.get("title_settings")
        
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem()
        self.talbeView.registerNib(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.talbeView.registerNib(UINib(nibName: "PushStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "cell_push")
        self.talbeView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell2")
        makeCall(Page.settings, params: [:]) { (response) in
            self.dictionary = response as! NSDictionary
        }
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
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch section {
        case 0:
            count = self.section1.count
        case 1:
            count = self.section2.count
        case 2:
            count = self.section3.count
        default:
            count = 0
        }
        return count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.talbeView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let vc:SelectLanguageViewController = SelectLanguageViewController(nibName: "SelectLanguageViewController", bundle: nil)
                vc.delegate = self
                self.presentPopupViewController(vc, animationType: MJPopupViewAnimationSlideBottomTop)
                
//                let alert:UIAlertController = UIAlertController(title: nil, message: Localization.get("select_language"), preferredStyle: .ActionSheet)
//                alert.addAction(UIAlertAction(title: "English", style: .Default, handler: { (action) in
//                    Localization.changeLanguage(Localization.Language.English)
//                }))
//                alert.addAction(UIAlertAction(title: "Arabic", style: .Default, handler: { (action) in
//                    Localization.changeLanguage(Localization.Language.Arabic)
//                }))
//                alert.addAction(UIAlertAction(title: "French", style: .Default, handler: { (action) in
//                    Localization.changeLanguage(Localization.Language.French)
//                }))
//                self.presentViewController(alert, animated: true, completion: nil)
            } else if indexPath.row == 3 {
                let vc:FontPropertiesViewController = FontPropertiesViewController(nibName: "FontPropertiesViewController", bundle: nil)
                vc.delegate = self
                self.presentPopupViewController(vc, animationType: MJPopupViewAnimationSlideBottomTop)
            } else if indexPath.row == 2 {
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0: // contact us
                let vc:ContactusViewController = Utils.getViewController("ContactusViewController") as! ContactusViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case 1: // facebook
                let vc:BrowserViewController = Utils.getViewController("BrowserViewController") as! BrowserViewController
                vc.url = self.dictionary?.valueForKey("facebook") as? String
                self.navigationController?.pushViewController(vc, animated: true)
            case 2: // twitter
                let vc:BrowserViewController = Utils.getViewController("BrowserViewController") as! BrowserViewController
                vc.url = self.dictionary?.valueForKey("twitter") as? String
                self.navigationController?.pushViewController(vc, animated: true)
            case 3: // instagram
                let vc:BrowserViewController = Utils.getViewController("BrowserViewController") as! BrowserViewController
                vc.url = self.dictionary?.valueForKey("instagram") as? String
                self.navigationController?.pushViewController(vc, animated: true)
            case 4: // rating
                let vc:BrowserViewController = Utils.getViewController("BrowserViewController") as! BrowserViewController
                vc.url = self.dictionary?.valueForKey("app_store") as? String
                self.navigationController?.pushViewController(vc, animated: true)
            case 5: // suggest
                let vc:SuggestViewController = Utils.getViewController("SuggestViewController") as! SuggestViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case 6: // report
                let vc:BugReportViewController = Utils.getViewController("BugReportViewController") as! BugReportViewController
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                print("nothing")
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0: // whatsapp
                let url = NSURL(string: "whatsapp://send?text=")!
                if UIApplication.sharedApplication().canOpenURL(url) == true {
                    UIApplication.sharedApplication().openURL(url)
                } else {
                    self.showErrorAlert("whatsapp_missing")
                }
            case 1: // facebook
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
                    let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    facebookSheet.setInitialText("")
                    self.presentViewController(facebookSheet, animated: true, completion: nil)
                } else {
                    self.showErrorAlert("facebook_missing")
                }
            case 2: // twiiter
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
                    let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    twitterSheet.setInitialText("")
                    self.presentViewController(twitterSheet, animated: true, completion: nil)
                } else {
                    self.showErrorAlert("twitter_missing")
                }
                
            case 3: // instagram
                let vc:BrowserViewController = Utils.getViewController("BrowserViewController") as! BrowserViewController
                vc.url = self.dictionary?.valueForKey("instagram") as? String
                self.navigationController?.pushViewController(vc, animated: true)
            case 4: // google plus
                let vc:BrowserViewController = Utils.getViewController("BrowserViewController") as! BrowserViewController
                vc.url = self.dictionary?.valueForKey("google_plus") as? String
                self.navigationController?.pushViewController(vc, animated: true)
            case 5: // linked in
                let vc:BrowserViewController = Utils.getViewController("BrowserViewController") as! BrowserViewController
                vc.url = self.dictionary?.valueForKey("linked_in") as? String
                self.navigationController?.pushViewController(vc, animated: true)
            case 6:
                if  MFMailComposeViewController.canSendMail() {
                    let vc:MFMailComposeViewController = MFMailComposeViewController()
                    vc.mailComposeDelegate = self
                    self.presentViewController(vc, animated: true, completion: nil)
                } else {
                    self.showErrorAlert("mail_app_missing")
                }
            case 7:
                if  MFMessageComposeViewController.canSendText() {
                    let vc:MFMessageComposeViewController = MFMessageComposeViewController()
                    vc.messageComposeDelegate = self
                    self.presentViewController(vc, animated: true, completion: nil)
                } else {
                    self.showErrorAlert("message_app_missing")
                }
            default:
                print("nothing")
            }
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textAlignment = NSTextAlignment.Right
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if section == 0 {
            title = Localization.get("title_settings")
        } else if section == 1 {
            title = Localization.get("title_nashrapp")
        } else if section == 2 {
            title = Localization.get("title_share_nashr")
        }
        return title
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                let cell:UITableViewCell = talbeView.dequeueReusableCellWithIdentifier("cell_push")!
                return cell
            } else {
                let cell:UITableViewCell = talbeView.dequeueReusableCellWithIdentifier("cell2")!
    //            cell.semanticContentAttribute = .ForceRightToLeft
    //            cell.textLabel?.semanticContentAttribute = .ForceRightToLeft
                cell.textLabel?.text = section1[indexPath.row]
    //            if indexPath.row == 1 {
    //                cell.accessoryView = UISwitch(frame: CGRectMake(0, 0, 40, 40))
    //            }
                cell.textLabel?.textAlignment = .Right
                
                return cell
            }
        } else {
            let cell:SettingsTableViewCell = talbeView.dequeueReusableCellWithIdentifier("cell") as! SettingsTableViewCell
//            cell.semanticContentAttribute = .ForceRightToLeft
//            cell.imageViewIcon.semanticContentAttribute = .ForceRightToLeft
//            cell.labelTitle?.semanticContentAttribute = .ForceRightToLeft
            var title = ""
            if indexPath.section == 1 {
                title = section2[indexPath.row]
                cell.imageViewIcon?.image  = UIImage(named: section2Icons[indexPath.row])
            } else if indexPath.section == 2 {
                title = section3[indexPath.row]
                cell.imageViewIcon?.image  = UIImage(named: section3Icons[indexPath.row])
            }
            
            cell.labelTitle?.text = title
            return cell
        }
    }
}
