//
//  FeedShareViewController.swift
//  Nashr
//
//  Created by User on 01/08/16.
//  Copyright © 2016 User. All rights reserved.
//

import UIKit
import MessageUI
import Social
//import DMActivityInstagram
import Alamofire
import SVProgressHUD
import FBSDKShareKit
import FBSDKMessengerShareKit

class FeedShareViewController: BaseViewController, MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var openBtnImage: UIImageView!
    
    @IBOutlet weak var heightOfReport: NSLayoutConstraint!
    @IBOutlet weak var copylinkImage: UIImageView!
    @IBOutlet weak var labelShare: UILabel!
    @IBOutlet weak var buttonOpen: UIButton!
    @IBOutlet weak var buttonCopyLink: UIButton!
    @IBOutlet weak var buttonReportAbuse: UIButton!
    @IBOutlet weak var buttonShowMore: UIButton!

    
    var shareWithFacebook:(() -> Void)?
    var shareWithGoogle:(() -> Void)?
    var feed:Feed?
    
    var delegate:PopupCloseDelegate?
    var dictionary = (UIApplication.sharedApplication().delegate as! AppDelegate).dictionary
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelShare.text = Localization.get("share_news")
        if Settings.nightMode == true {
            self.buttonOpen.setTitleColor(UIColor.whiteColor(), forState:.Normal)
            if (self.feed!.link == nil) || (self.feed!.link.isEmpty == true) {
                self.buttonCopyLink.setTitleColor(UIColor.grayColor(), forState:.Normal)
                self.buttonCopyLink.hidden=true
                self.buttonOpen.hidden=true
                self.openBtnImage.hidden=true
                self.copylinkImage.hidden=true
                heightOfReport.constant = 19

            } else {
                heightOfReport.constant = 91

                self.openBtnImage.hidden=false
                self.copylinkImage.hidden=false
                self.buttonCopyLink.hidden=false
                self.buttonOpen.hidden=false
                self.buttonCopyLink.setTitleColor(UIColor.whiteColor(), forState:.Normal)
                //self.buttonCopyLink.addTarget(self, action: Selector(copyLink(buttonCopyLink)), forControlEvents:.TouchUpInside)
                self.buttonCopyLink.addTarget(self, action: #selector(copyLink), forControlEvents: .TouchUpInside)

            }
            self.buttonReportAbuse.setTitleColor(UIColor.whiteColor(), forState:.Normal)
            self.buttonShowMore.setTitleColor(UIColor.whiteColor(), forState:.Normal)

        }
        else{
            self.buttonOpen.setTitleColor(UIColor.blackColor(), forState:.Normal)
            if (self.feed!.link == nil) || (self.feed!.link.isEmpty == true) {
                self.buttonCopyLink.setTitleColor(UIColor.grayColor(), forState:.Normal)
                self.buttonCopyLink.hidden=true
                self.buttonOpen.hidden=true
                self.openBtnImage.hidden=true
                self.copylinkImage.hidden=true
                heightOfReport.constant = 19

            } else {
                heightOfReport.constant = 91

                self.openBtnImage.hidden=false
                self.copylinkImage.hidden=false
                self.buttonCopyLink.hidden=false
                self.buttonOpen.hidden=false
                self.buttonCopyLink.setTitleColor(UIColor.blackColor(), forState:.Normal)
                //self.buttonCopyLink.addTarget(self, action: Selector(copyLink(buttonCopyLink)), forControlEvents:.TouchUpInside)
                self.buttonCopyLink.addTarget(self, action: #selector(copyLink), forControlEvents: .TouchUpInside)


            }
            self.buttonReportAbuse.setTitleColor(UIColor.blackColor(), forState:.Normal)
            self.buttonShowMore.setTitleColor(UIColor.blackColor(), forState:.Normal)
        }
        
        self.buttonOpen.setTitle(Localization.get("open_in_browser"), forState: .Normal)
        self.buttonCopyLink.setTitle(Localization.get("copy_link"), forState: .Normal)
        self.buttonReportAbuse.setTitle(Localization.get("title_report_abuse"), forState: .Normal)
        self.buttonShowMore.setTitle(Localization.get("show_more"), forState: .Normal)
        self.view.mixedBackgroundColor = MixedColor(normal: normal_background, night: night_background)

    }
    override func viewWillAppear(animated: Bool) {
        //self.tabBarController?.tabBar.hidden = true
        let tracker = GAI.sharedInstance().trackerWithTrackingId("UA-90639520-1")
        GAI.sharedInstance().trackUncaughtExceptions = true
        tracker.set(kGAIScreenName, value: "FeedShare")
        let eventTracker: NSObject = GAIDictionaryBuilder.createScreenView().build()
        tracker.send(eventTracker as! [NSObject : AnyObject])
    }
    @IBAction func close(sender: AnyObject) {
        self.delegate?.closePopup(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    var documentController: UIDocumentInteractionController?
    @IBAction func shareOnInstagram(sender: AnyObject) {
        SVProgressHUD.showImage(UIImage(named: "logo.png"), status: "")
        Alamofire.request(.GET, self.feed!.instaImg).response(completionHandler: { (request, response, data, error) in
            SVProgressHUD.dismiss()
                let imageData = data
                let writePath = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("instagram.igo")
                imageData?.writeToFile(writePath, atomically: true)
            
                dispatch_async(dispatch_get_main_queue(),{
                    let instagramURL = NSURL(string: "instagram://app")
                    
                    if (UIApplication.sharedApplication().canOpenURL(instagramURL!)) {
                        
                        let captionString = self.feed!.Title
                        let fileURL = NSURL(fileURLWithPath: writePath)
                        self.documentController = UIDocumentInteractionController(URL: fileURL)
                        self.documentController!.UTI = "com.instagram.exlusivegram"
                        self.documentController!.annotation = NSDictionary(object: captionString, forKey: "InstagramCaption")
                        self.documentController!.presentOpenInMenuFromRect(self.view.frame, inView: self.view, animated: true)
                        
                    } else {
                        print(" Instagram isn't installed ")
                    }
                })
        })
    }
        
    @IBAction func shareOnFacebook(sender: AnyObject) {
//        let share : FBSDKShareLinkContent = FBSDKShareLinkContent()
//        share.imageURL = NSURL(string:self.feed!.image)
//        share.contentTitle = self.feed!.Title
//        share.contentDescription = self.feed!.facebookStr
//        share.contentURL = NSURL(string: self.feed!.link)
//        
//        let dialog : FBSDKShareDialog = FBSDKShareDialog()
//        dialog.fromViewController = self
//        dialog.shareContent = share
//        dialog.mode = FBSDKShareDialogMode.Native
//        if !dialog.canShow() {
//            dialog.mode = .FeedWeb
//        }
//        dialog.show()
        /*
        let share : FBSDKShareLinkContent = FBSDKShareLinkContent()
        share.imageURL = NSURL(string:Utils.getDecodedString(self.feed!.image))
        share.contentTitle = Utils.getDecodedString(self.feed!.Title)
        share.contentDescription = self.feed!.facebookStr
        share.contentURL = NSURL(string: Utils.getDecodedString(self.feed!.web_link))
        
        let dialog : FBSDKShareDialog = FBSDKShareDialog()
        dialog.fromViewController = self
        dialog.shareContent = share
        dialog.mode = FBSDKShareDialogMode.Native
        if !dialog.canShow() {
            dialog.mode = .FeedWeb
        }
        dialog.show()
        */
        
        let share : FBSDKShareLinkContent = FBSDKShareLinkContent()
        share.imageURL = NSURL(string:Utils.getDecodedString(self.feed!.image))
        share.contentTitle = Utils.getDecodedString(self.feed!.Title)
        share.contentDescription = self.feed!.facebookStr
        share.contentURL = NSURL(string: Utils.getDecodedString(self.feed!.web_link))
        
        let dialog : FBSDKShareDialog = FBSDKShareDialog()
        dialog.fromViewController = self
        dialog.shareContent = share
        dialog.mode = FBSDKShareDialogMode.Native
        if !dialog.canShow() {
            dialog.mode = .FeedWeb
        }
        dialog.show()
//        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
//            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            facebookSheet.setInitialText(self.feed!.facebookStr)
//            self.presentViewController(facebookSheet, animated: true, completion: nil)
//        } else {
//            self.showErrorAlert("facebook_missing")
//        }

        self.delegate?.closePopup(self)
    }
    
    @IBAction func shareOnTwitter(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText(self.feed!.twitterStr)
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            self.showErrorAlert("twitter_missing")
        }
        
        self.delegate?.closePopup(self)
    }
    
    @IBAction func shareOnWhatsapp(sender: AnyObject) {
        let urlStringEncoded = String(format: "whatsapp://send?text=%@", self.feed!.whatsappStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!)
        let url = NSURL(string: urlStringEncoded)
        if url != nil {
            if UIApplication.sharedApplication().canOpenURL(url!) == true {
                UIApplication.sharedApplication().openURL(url!)
            } else {
                self.showErrorAlert("whatsapp_missing")
            }
        }
        self.delegate?.closePopup(self)
    }
    
    @IBAction func shareOnGooglePlus(sender: AnyObject) {
        self.shareWithGoogle?()
        self.delegate?.closePopup(self)
    }
    
    @IBAction func shareOnLinkedIn(sender: AnyObject) {
        let vc:BrowserViewController = Utils.getViewController("BrowserViewController") as! BrowserViewController
        vc.url = self.dictionary?.valueForKey("linked_in") as? String
        (self.delegate as! UIViewController).navigationController?.pushViewController(vc, animated: true)
        self.delegate?.closePopup(self)
    }
    
    @IBAction func shareOnSMS(sender: AnyObject) {
        if  MFMessageComposeViewController.canSendText() {
            let vc:MFMessageComposeViewController = MFMessageComposeViewController()
            vc.messageComposeDelegate = self
            vc.body = Utils.getDecodedString(self.feed!.web_link)
            self.presentViewController(vc, animated: true, completion: nil)
        } else {
            self.showErrorAlert("message_app_missing")
        }
        self.delegate?.closePopup(self)
    }
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion:nil)
        if result == .Cancelled {
            print("Message cancelled")
        }
        else if result == .Sent {
            print("Message sent")
        }
        else {
            print("Message failed")
        }
        
    }
    @IBAction func shareOnEmail(sender: AnyObject) {
//        if  MFMailComposeViewController.canSendMail() {
//            let vc:MFMailComposeViewController = MFMailComposeViewController()
//            vc.mailComposeDelegate = self
//            vc.setMessageBody(Utils.getDecodedString(self.feed!.mailStr), isHTML: true)
//            
//            vc.setToRecipients([self.dictionary!.valueForKey("email") as! String])
//            self.presentViewController(vc, animated: true, completion: nil)
//        } else {
//            self.showErrorAlert("mail_app_missing")
//        }
//        self.delegate?.closePopup(self)

        if  MFMailComposeViewController.canSendMail() {
            let vc:MFMailComposeViewController = MFMailComposeViewController()
            vc.mailComposeDelegate = self
            vc.setMessageBody(Utils.getDecodedString(self.feed!.mailStr
                ), isHTML: true)
            
            vc.setToRecipients([self.dictionary!.valueForKey("email") as! String])
            self.presentViewController(vc, animated: true, completion: nil)
        } else {
            self.showErrorAlert("mail_app_missing")
        }
        self.delegate?.closePopup(self)
    }
   
    @IBAction func openInBrowser(sender: AnyObject) {
        let url = NSURL(string: Utils.getDecodedString(self.feed!.link))
        UIApplication.sharedApplication().openURL(url!)
        self.delegate?.closePopup(self)
    }
    
    @IBAction func copyLink(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = Utils.getDecodedString(self.feed!.web_link)
        self.delegate?.closePopup(self)
    }
    
    @IBAction func showMore(sender: AnyObject) {
        let activityViewController = UIActivityViewController(activityItems: [self.feed!.Title, self.feed!.link], applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func reportAbuse(sender: AnyObject) {
        let vc:ReportAbuseViewController = Utils.getViewController("ReportAbuseViewController") as! ReportAbuseViewController
        vc.newsId = self.feed?.id
        (self.delegate as! UIViewController).navigationController?.pushViewController(vc, animated: true)
        self.delegate?.closePopup(self)
    }
    
}
