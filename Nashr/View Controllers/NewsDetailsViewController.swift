//
//  NewsDetailsViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 01/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import IDMPhotoBrowser
import MessageUI
import Social
import Alamofire
import SVProgressHUD
import FBSDKShareKit
import FBSDKMessengerShareKit
import XCDYouTubeKit

class NewsDetailsViewController: BaseViewController, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    var fontSize = 10
    var fontStyle = "normal"
    
    var feedId:String?
    var feed:Feed?
    var documentController:UIDocumentInteractionController?
    
    @IBOutlet weak var labelFontStyle: UILabel!
    @IBOutlet weak var labelChangeFont: UILabel!
    var dictionary:NSDictionary?
    
    @IBOutlet weak var viewChangeFont: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fontStyleOptions: UISegmentedControl!
    @IBOutlet weak var sliderFontSize: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttons = UIView(frame: CGRectZero)
        
        self.labelFontStyle.text = Localization.get("font_style")
        self.labelChangeFont.text = Localization.get("change_font")
        
        self.fontStyleOptions.setTitle(Localization.get("normal"), forSegmentAtIndex: 0)
        self.fontStyleOptions.setTitle(Localization.get("bold"), forSegmentAtIndex: 1)
        
        let buttonAction: UIButton = UIButton(type: .Custom)
        buttonAction.setImage(Utils.getTemplateImage("action.png"), forState: .Normal)
        buttonAction.addTarget(self, action: #selector(takeAction), forControlEvents: .TouchUpInside)
        buttonAction.tintColor = UIColor.whiteColor()
        buttons.addSubview(buttonAction)
        
        let buttonComments: UIButton = UIButton(type: .Custom)
        buttonComments.setImage(Utils.getTemplateImage("comments.png"), forState: .Normal)
        buttonComments.addTarget(self, action: #selector(showComments), forControlEvents: .TouchUpInside)
        buttonComments.tintColor = UIColor.whiteColor()
        buttons.addSubview(buttonComments)
        
        let buttonFavorite: UIButton = UIButton(type: .Custom)
        buttonFavorite.setImage(Utils.getTemplateImage("add_to_favorite.png"), forState: .Normal)
        buttonFavorite.addTarget(self, action: #selector(toggleFavorite), forControlEvents: .TouchUpInside)
        buttonFavorite.tintColor = UIColor.whiteColor()
        buttons.addSubview(buttonFavorite)
        
        let buttonWorld: UIButton = UIButton(type: .Custom)
        buttonWorld.setImage(Utils.getTemplateImage("open_in_web.png"), forState: .Normal)
        buttonWorld.addTarget(self, action: #selector(openInSafari), forControlEvents: .TouchUpInside)
        buttonWorld.tintColor = UIColor.whiteColor()
        buttons.addSubview(buttonWorld)
        
        let buttonChangeFont: UIButton = UIButton(type: .Custom)
        buttonChangeFont.setImage(Utils.getTemplateImage("font.png"), forState: .Normal)
        buttonChangeFont.addTarget(self, action: #selector(changeFont), forControlEvents: .TouchUpInside)
        buttonChangeFont.tintColor = UIColor.whiteColor()
        buttons.addSubview(buttonChangeFont)
        
        var rect = CGRectMake(0, 0, 35, 35)
        buttonChangeFont.frame = rect
        
        rect.origin.x += 40
        buttonWorld.frame = rect
        
//        rect.origin.x += 40
//        buttonFavorite.frame = rect
//        
//        rect.origin.x += 40
//        buttonComments.frame = rect
//        
        rect.origin.x += 40
        buttonAction.frame = rect

        buttons.frame = CGRectMake(0, 0, rect.origin.x + 35, 40);
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttons)
        
//        self.labelTitle.text = self.feed!.Title
//        if let imageURL = NSURL(string:self.feed!.image) {
//            self.imageViewFeed.setImageWithURL(imageURL)
//        }
//        
//        if let imageURL = NSURL(string:self.feed!.chanel.image) {
//            self.imageViewIcon.setImageWithURL(imageURL)
//        }
//        
//        self.webView.delegate = self
//        reloadDescription()
        
//        self.viewChangeFont.frame = self.view.bounds
        self.view.bringSubviewToFront(self.viewChangeFont)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideFontView))
        self.viewChangeFont.addGestureRecognizer(gesture)
        
        self.tableView.backgroundColor = UIColor.clearColor()
        
        
        self.tableView.registerNib(UINib(nibName: "PagerTableViewCell", bundle: nil), forCellReuseIdentifier: "pager_cell")
        self.tableView.registerNib(UINib(nibName: "UrgentNewsItemDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "urgent_cell_header")
        self.tableView.registerNib(UINib(nibName: "NewsItemDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell_header")
        self.tableView.registerNib(UINib(nibName: "FeedTextTableViewCell", bundle: nil), forCellReuseIdentifier: "cell_details")
        self.tableView.registerNib(UINib(nibName: "DetailsShareTableViewCell", bundle: nil), forCellReuseIdentifier: "cell_share")
        
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
//
        let font = Settings.currentFont
        if font.size == 0 || font.style.isEmpty == true {
            Settings.currentFont = (20, "normal")
            self.fontSize = 20
            self.fontStyle = "normal"
        } else {
            self.fontSize = font.size
            self.fontStyle = font.style
          
            self.sliderFontSize.value = Float(font.size)
            self.fontStyleOptions.selectedSegmentIndex = (font.style == "normal") ? 0 : 1
        }
        
        self.dictionary = (UIApplication.sharedApplication().delegate as! AppDelegate).dictionary
        
//        makeCall(Page.settings, params: [:]) { (response) in
//            self.dictionary = response as? NSDictionary
//        }
        
        if (self.feed == nil) && (self.feedId != nil) {
            self.makeCall(Page.feeds, params: ["feed_id":self.feedId!], completionHandler: { (response) in
                let array = response as! NSArray
                if array.count > 0 {
                    self.feed = Feed(fromDictionary: array[0] as! NSDictionary)
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func hideFontView() {
        UIView.animateWithDuration(0.5) {
            self.viewChangeFont.alpha = 0
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        UIView.animateWithDuration(0.5) { 
//            self.viewChangeFont.alpha = 0
//        }
//    }
    
    func takeAction() {
        let vc = FeedShareViewController(nibName: "FeedShareViewController", bundle: nil)
        vc.delegate = self
        vc.feed = self.feed
        vc.dictionary = self.dictionary
        vc.shareWithGoogle = {
            let vc:BrowserViewController = Utils.getViewController("BrowserViewController") as! BrowserViewController
            vc.url = self.dictionary!.valueForKey("google_plus") as? String
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.presentPopupViewController(vc, animationType: MJPopupViewAnimationSlideBottomTop)
    }

    func changeFont(sender:UIButton) {
        //self.viewChangeFont.center = CGPointMake(self.view.center.x, 90)
        UIView.animateWithDuration(0.5) {
            if self.viewChangeFont.alpha == 0 {
                self.viewChangeFont.alpha = 1
            } else {
                self.viewChangeFont.alpha = 0
            }
        }
    }
    
    func openInSafari() {
        let url = NSURL(string: self.feed!.link.stringByAddingPercentEscapesUsingEncoding(NSUTF16StringEncoding)!)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func toggleFavorite() {
        
    }
    
    func showComments() {
        
    }
    
    @IBAction func changeFontSize(sender: AnyObject) {
        let slider:UISlider = sender as! UISlider
        self.fontSize = Int(slider.value)
        Settings.currentFont = (self.fontSize, self.fontStyle)
        reloadDescription()
    }
    
    @IBAction func changeFontStyle(sender: AnyObject) {
        let options:UISegmentedControl = sender as! UISegmentedControl
        if options.selectedSegmentIndex == 0 {
            self.fontStyle = "normal"
        } else {
            self.fontStyle = "bold"
        }
        
        Settings.currentFont = (self.fontSize, self.fontStyle)
        reloadDescription()
    }
    
    func reloadDescription() {
        self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 2)], withRowAnimation: .None)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.feed == nil ? 0 : 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return self.feed!.image.isEmpty ? 0 : 1
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height:CGFloat = 44.0
        if indexPath.section == 0 {
            height = UITableViewAutomaticDimension
        } else if indexPath.section == 1 {
            height = 200
        } else if indexPath.section == 2 {
            height = UITableViewAutomaticDimension
        } else if indexPath.section == 3 {
            height = 117
        }
        
        return height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if !self.feed!.video.isEmpty {
                if let url = NSURL(string: self.feed!.video) {
                    UIApplication.sharedApplication().openURL(url)
                }
                
            } else {
                self.showImageSlideShow()
            }
        }
    }
    
    func showImageSlideShow() {
        var images:[String] = []
        if self.feed!.gallery.count == 0 {
            images.append(self.feed!.image)
        } else {
            for image in self.feed!.gallery {
                images.append(image as! String)
            }
        }
        
        if images.count > 0 {
            var photos:[IDMPhoto] = []
            for image in images {
                let photo:IDMPhoto = IDMPhoto(URL: NSURL(string: image))
                photos.append(photo)
            }
            
            let browser = IDMPhotoBrowser(photos: photos)
            browser.doneButtonImage = UIImage(named: "photo_browser_close.png")
            browser.displayActionButton = false
            self.presentViewController(browser, animated: true, completion: nil)
        }
    }
    
    func extractYoutubeIdFromLink(link: String) -> String? {
        
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .CaseInsensitive) else {
            return nil
        }
        let nsLink = link as NSString
        let options = NSMatchingOptions(rawValue: 0)
        let range = NSRange(location: 0,length: nsLink.length)
        let matches = regExp.matchesInString(link as String, options:options, range:range)
        if let firstMatch = matches.first {
            print(firstMatch)
            return nsLink.substringWithRange(firstMatch.range)
        }
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell:NewsItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.feed!.isUrgent == 1 ? "urgent_cell_header" :"cell_header") as! NewsItemTableViewCell
            cell.selectionStyle = .None
            cell.showFeed(self.feed!)
            cell.selectChannel = {
                let vc:ChannelDetailsViewController = Utils.getViewController("ChannelDetailsViewController") as! ChannelDetailsViewController
                vc.channel = self.feed!.chanel
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()

            return cell
        } else if indexPath.section == 1 {
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier("pager_cell") as! PagerTableViewCell
            
            var images:[String] = []
            if self.feed!.gallery.count == 0 {
                images.append(self.feed!.image)
            } else {
                for image in self.feed!.gallery {
                    images.append(image as! String)
                }
            }
            
            cell.imageSelected = {
                if !self.feed!.video.isEmpty {
                    let youtubeId = self.extractYoutubeIdFromLink(self.feed!.video)
                    if youtubeId != nil {
                        let vc:XCDYouTubeVideoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: youtubeId)
                        self.presentViewController(vc, animated: true, completion: nil)
                    }
                } else {
                    self.showImageSlideShow()
                }
            }
            
            cell.startVideo = {
                let youtubeId = self.extractYoutubeIdFromLink(self.feed!.video)
                if youtubeId != nil {
                    let vc:XCDYouTubeVideoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: youtubeId)
                    self.presentViewController(vc, animated: true, completion: nil)
                }
            }
            
            if self.feed!.video.isEmpty {
                cell.videoIcon?.hidden = true
                cell.buttonPlay?.hidden = true
            } else {
                cell.videoIcon?.hidden = false
                cell.buttonPlay?.hidden = false
            }

            cell.showImages(images)
            return cell
            
        } else if indexPath.section == 2 {
            let cell:FeedTextTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell_details") as! FeedTextTableViewCell
            cell.labelDescription.preferredMaxLayoutWidth = CGRectGetWidth(self.tableView.bounds)
            cell.selectionStyle = .None
            if self.feed!.data.characters.count > 0 {
                let html = "<html><head><style>p{line-height:1.5em;font-size:\(self.fontSize)px;font-weight:\(self.fontStyle);font-family:\"NotoNaskhArabic\";color:#666666;}</style></head><body>\(self.feed!.data)<br/><br/><br/><br/></body></html>"
                let attrStr = try! NSAttributedString(data: html.dataUsingEncoding(NSUTF16StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
                cell.labelDescription.attributedText = attrStr
            } else {
                cell.labelDescription.text = ""
            }
            return cell
        } else if indexPath.section == 3 {
            let cell:DetailsShareTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell_share") as! DetailsShareTableViewCell
            cell.selectionStyle = .None
            if (self.feed!.link == nil) || (self.feed!.link.isEmpty == true) {
                cell.buttonMore.hidden = true
            } else {
                cell.buttonMore.hidden = false
            }
            //cell.buttonMore.hidden = (self.feed!.link == nil)
            cell.showMoreDetails = {
                self.openInSafari()
            }
            
            cell.showEmailOption = {
                if  MFMailComposeViewController.canSendMail() {
                    let vc:MFMailComposeViewController = MFMailComposeViewController()
                    vc.mailComposeDelegate = self
                    vc.setMessageBody(self.feed!.mailStr, isHTML: true)
                    vc.setToRecipients([self.dictionary!.valueForKey("email") as! String])
                    self.presentViewController(vc, animated: true, completion: nil)
                } else {
                    self.showErrorAlert("mail_app_missing")
                }
            }
            cell.showWhatsappOption = {
                if self.feed!.whatsappStr != nil {
                    let urlStringEncoded = String(format: "whatsapp://send?text=%@", self.feed!.whatsappStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!)
                    let url = NSURL(string: urlStringEncoded)
                    if url != nil {
                        if UIApplication.sharedApplication().canOpenURL(url!) == true {
                            UIApplication.sharedApplication().openURL(url!)
                        } else {
                            self.showErrorAlert("whatsapp_missing")
                        }
                    }
                }
            }
            
            cell.showInstagramOption = {
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
            cell.showFacebookOption = {
                
                let share : FBSDKShareLinkContent = FBSDKShareLinkContent()
                share.imageURL = NSURL(string:self.feed!.image)
                share.contentTitle = self.feed!.Title
                share.contentDescription = self.feed!.facebookStr
                share.contentURL = NSURL(string: self.feed!.link)
                
                let dialog : FBSDKShareDialog = FBSDKShareDialog()
                dialog.fromViewController = self
                dialog.shareContent = share
                dialog.mode = FBSDKShareDialogMode.Native
                if !dialog.canShow() {
                    dialog.mode = .FeedWeb
                }
                dialog.show()
                
//                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
//                    let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//                    facebookSheet.setInitialText(self.feed!.facebookStr)
//                    self.presentViewController(facebookSheet, animated: true, completion: nil)
//                } else {
//                    self.showErrorAlert("facebook_missing")
//                }
            }
            cell.showTwitterOption = {
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
                    let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    twitterSheet.setInitialText(self.feed!.twitterStr)
                    self.presentViewController(twitterSheet, animated: true, completion: nil)
                } else {
                    self.showErrorAlert("twitter_missing")
                }

            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
