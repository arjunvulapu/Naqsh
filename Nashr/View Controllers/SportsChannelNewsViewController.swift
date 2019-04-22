//
//  ChannelNewsViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 16/11/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet
import Social
import FBSDKShareKit

class ChannelNewsViewController: BaseViewController, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    @IBOutlet weak var buttonScrollUp: UIButton!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    var feedType:FeedType = .Latest, lastFeedType:FeedType = .Latest
    var params:[String:AnyObject] = [:]
    var refreshControl:UIRefreshControl = UIRefreshControl()
    var feeds:[Feed] = []
    var countryId = ""
    var channels:[Chanel] = []

    var source = "", sourceTitle = "", currentSource = ""
    var firstId = "", lastId = ""
    var showingChannels:NSString=""
    var selectedButton : NSString = ""
    var searchResults:Array<Chanel> = []
    var searchActive : Bool = false
    @IBInspectable var parentCategory:String = "0"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var topOfTable: NSLayoutConstraint!
    
    @IBAction func searchFeeds(sender: AnyObject) {
        let vc:SearchViewController = Utils.getViewController("SearchViewController") as! SearchViewController
        vc.searchParams = self.params
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func cancelSearch() {
        var sender:UIButton? = nil
        self.params.removeAll()
        return
        
        if feedType == .Latest {
            sender = self.button1
        } else if self.feedType == .Source {
            feedType = .Source
            reloadData()
            return
        }
        
        selectType(sender!)
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText=="")
        {
            searchActive = false;
            tableView.reloadData()
            return
        }
        if self.channels.count == 0 {
            return
        }
        self.searchResults = self.channels.filter({( aSpecies: Chanel) -> Bool in
            // to start, let's just search by name
            print(aSpecies.title)
            return (aSpecies.title!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil)||(aSpecies.titleAr.rangeOfString(searchText.lowercaseString) != nil)
        })
        
        if(searchResults.count == 0){
            
            searchActive = true;
            self.tableView.reloadData()
            
        } else {
            searchActive = true;
            self.tableView.reloadData()
            
        }
    }

    @IBAction func scrollUp(sender: AnyObject) {
        //if self.newFeedsArray == nil { return }
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
        self.buttonScrollUp.hidden = true
    }
    
    func searchWithText(text: String) {
        self.params.removeAll()
        if feedType == .Latest {
            params["type"] = "latest"
        } else if self.feedType == .Source {
            params["type"] = "source"
        }
        
        self.lastId = ""
        if text.characters.count > 0 {
            params["search"] = text
        }
        self.fetchFeeds(true)
    }
    
    let pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedButton="1"
        var textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        
        textFieldInsideSearchBar?.mixedTextColor=MixedColor(normal:normal_text , night: night_text)
        self.view.mixedBackgroundColor = MixedColor(normal:0x008097 , night: 0x283541)
        self.tableView.mixedBackgroundColor = MixedColor(normal: normal_background, night: night_background)
        
        self.buttonScrollUp.backgroundColor = UIColor(red:0.941,  green:0.945,  blue:0.949, alpha:1)
        self.buttonScrollUp.tintColor = UIColor.darkGrayColor()
        self.buttonScrollUp.layer.cornerRadius = 5
        self.buttonScrollUp.layer.borderColor = UIColor.whiteColor().CGColor
        self.buttonScrollUp.layer.borderWidth = 1
        self.buttonScrollUp.clipsToBounds = false
        self.buttonScrollUp.hidden = true
        
        self.buttonScrollUp.setTitle(Localization.get("scroll_up_message"), forState: .Normal)
//        
//        self.buttonContainer.layer.cornerRadius = 5
//        self.buttonContainer.clipsToBounds = true
//        self.buttonContainer.layer.borderColor = theme_color.CGColor
//        self.buttonContainer.layer.borderWidth = 1
        self.buttonContainer.mixedBackgroundColor = MixedColor(normal: 0x097f9a, night: 0x283541)
        let radius: CGFloat = self.buttonContainer.frame.width / 2.0 //change it to .height if you need spread for height
       let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 35, width: 2.1 * radius, height: self.buttonContainer.frame.height-35))
        //Change 2.1 to amount of spread you need and for height replace the code for height
        
        self.buttonContainer.layer.cornerRadius = 2
        self.buttonContainer.layer.shadowColor = UIColor.blackColor().CGColor
        self.buttonContainer.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)  //Here you control x and y
        self.buttonContainer.layer.shadowOpacity = 0.5
        self.buttonContainer.layer.shadowRadius = 5.0 //Here your control your blur
        self.buttonContainer.layer.masksToBounds =  false
        self.buttonContainer.layer.shadowPath = shadowPath.CGPath
        pagingSpinner.color = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        pagingSpinner.hidesWhenStopped = true
        pagingSpinner.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44);
        tableView.tableFooterView = pagingSpinner
        
        self.navigationItem.title = Localization.get("tab_news")
        
        //self.view.backgroundColor = UIColor.whiteColor()
        
        
        self.tableView.registerNib(UINib(nibName: "AdTableViewCell", bundle: nil), forCellReuseIdentifier: "cell_ad")
        self.tableView.registerNib(UINib(nibName: "GoogleAdTableViewCell", bundle: nil), forCellReuseIdentifier: "cell_gad")

        self.tableView.registerNib(UINib(nibName: "UrgentNewsItemTableViewCell", bundle: nil), forCellReuseIdentifier: "urgentcell")
        self.tableView.registerNib(UINib(nibName: "UrgentNewsTextItemTableViewCell", bundle: nil), forCellReuseIdentifier: "urgentcelltext")
        self.tableView.registerNib(UINib(nibName: "NewsItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.registerNib(UINib(nibName: "NewsItemTextTableViewCell", bundle: nil), forCellReuseIdentifier: "celltext")
        self.tableView.registerNib(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "Channelcell")

        //self.tableView.backgroundColor = UIColor.clearColor()
        
        self.refreshControl.addTarget(self, action: #selector(reloadData), forControlEvents: .ValueChanged)
        self.refreshControl.backgroundColor = UIColor(red:0.874,  green:0.875,  blue:0.874, alpha:1)

        self.tableView.addSubview(self.refreshControl)
        
//        self.button1.layer.borderColor = theme_color.CGColor
//        self.button1.layer.borderWidth = 1
        self.button1.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.button1.addTarget(self, action: #selector(selectType), forControlEvents: .TouchUpInside)
        
//        self.button2.layer.borderColor = theme_color.CGColor
//        self.button2.layer.borderWidth = 1
        self.button2.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.button2.addTarget(self, action: #selector(selectType), forControlEvents: .TouchUpInside)
        
        self.button1.setTitle(Localization.get("latest"), forState: .Normal)
        self.button2.setTitle(Localization.get("source"), forState: .Normal)
        
        NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: #selector(fetchNewFeeds), userInfo: nil, repeats: true)
    
        resetButtons()
        
        //        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = 65.0

        //selectType(self.button1)
        let items = try! Realm().objects(SavedCategory)
        if items.count == 0 {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sourceSelected), name: "AddedGeneralNewsSource", object: nil)
        }
        
        //TitleFontChanged
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(titleFontChanged), name: "TitleFontChanged", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sourceSelected), name: "NoNewsSource", object: nil)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadData), name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        if !Localization.isLanguageSet() {
            //            let vc:SelectLanguageViewController = SelectLanguageViewController(nibName: "SelectLanguageViewController", bundle: nil)
            //            vc.delegate = self
            //            self.presentPopupViewController(vc, animationType: MJPopupViewAnimationSlideBottomTop)
            Localization.changeLanguage(Localization.Language.Arabic)
        } else {
            self.selectType(self.button1)
        }
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(NewsViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Left
        self.tableView.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(NewsViewController.respondToSwipeGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeDown)
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                self.typeByLeftSwipe()
                
                
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.Down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
                self.typeByRightSwipe()
                
                
                
            case UISwipeGestureRecognizerDirection.Up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    func typeByRightSwipe(){
        resetButtons()
        
        self.lastId = ""
        params.removeValueForKey("last_id")
        print ("scrolling to right")
        
        
        switch selectedButton {
        case "2":
            self.button1.backgroundColor = UIColor.clearColor()
            self.button1.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            let border = CALayer()
            let width = CGFloat(3.0)
            border.borderColor = UIColor.whiteColor().CGColor
            border.frame = CGRect(x: 0, y: button1.frame.size.height - width, width:  button1.frame.size.width, height: button1.frame.size.height)
            
            border.borderWidth = width
            button1.layer.addSublayer(border)
            button1.layer.masksToBounds = true
            self.navigationItem.title = button1.titleLabel?.text
            selectedButton="1"
            topOfTable.constant=0
            searchBar.hidden=true

            params["type"] = "latest"
            feedType = .Latest
            reloadData()
        case "1":
            button2.backgroundColor = UIColor.clearColor()
            button2.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            let border = CALayer()
            let width = CGFloat(3.0)
            border.borderColor = UIColor.whiteColor().CGColor
            border.frame = CGRect(x: 0, y: button2.frame.size.height - width, width:  button2.frame.size.width, height: button2.frame.size.height)
            
            border.borderWidth = width
            button2.layer.addSublayer(border)
            button2.layer.masksToBounds = true
            self.navigationItem.title = button2.titleLabel?.text
            self.source = ""
            selectedButton="2"
            topOfTable.constant=44
            searchBar.hidden=false

            params["type"] = "source"
            feedType = .Source
            let items = try! Realm().objects(SavedCategory)
            if items.count == 0 {
                self.feeds.removeAll()
                self.tableView.emptyDataSetDelegate = self
                self.tableView.emptyDataSetSource = self
                self.tableView.reloadData()
            } else {
                reloadData()
            }
                default:
            feedType = .Latest
            reloadData()
        }
    }
    func typeByLeftSwipe(){
        resetButtons()
        
        self.lastId = ""
        params.removeValueForKey("last_id")
        print ("scrolling to top")
        
        
        switch selectedButton {
        case "2":
            self.button1.backgroundColor = UIColor.clearColor()
            self.button1.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            let border = CALayer()
            let width = CGFloat(3.0)
            border.borderColor = UIColor.whiteColor().CGColor
            border.frame = CGRect(x: 0, y: button1.frame.size.height - width, width:  button1.frame.size.width, height: button1.frame.size.height)
            
            border.borderWidth = width
            button1.layer.addSublayer(border)
            button1.layer.masksToBounds = true
            self.navigationItem.title = button1.titleLabel?.text
            selectedButton="1"
            topOfTable.constant=0
            searchBar.hidden=true

            params["type"] = "latest"
            feedType = .Latest
            reloadData()
        case "1":
            button2.backgroundColor = UIColor.clearColor()
            button2.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            let border = CALayer()
            let width = CGFloat(3.0)
            border.borderColor = UIColor.whiteColor().CGColor
            border.frame = CGRect(x: 0, y: button2.frame.size.height - width, width:  button2.frame.size.width, height: button2.frame.size.height)
            
            border.borderWidth = width
            button2.layer.addSublayer(border)
            button2.layer.masksToBounds = true
            self.navigationItem.title = button2.titleLabel?.text
            self.source = ""
            selectedButton="2"
            topOfTable.constant=44
            searchBar.hidden=false

            params["type"] = "source"
            feedType = .Source
            let items = try! Realm().objects(SavedCategory)
            if items.count == 0 {
                self.feeds.removeAll()
                self.tableView.emptyDataSetDelegate = self
                self.tableView.emptyDataSetSource = self
                self.tableView.reloadData()
            } else {
                reloadData()
            }
                    
        default:
            feedType = .Latest
            reloadData()
        }
    }
    

    func titleFontChanged() {
        self.tableView.reloadData()
    }
    
    var newFeedsArray:[Feed]?
    func fetchNewFeeds() {
        if(showingChannels .isEqualToString("channels")){
            
        }else{
        if firstId.characters.count == 0 {
            return
        }
        
        print("loading new feeds from id: \(self.firstId)")
        var dictionary:[String:AnyObject] = [:]
        
        if self.feedType == .Source {
            dictionary["type"] = "source"
            dictionary["chanels"] = self.currentSource
        } else {
            let items = try! Realm().objects(SavedCategory)
            var channelIds:[String] = []
            
            if feedType == .Latest {
                dictionary["type"] = "latest"
                for cat in items {
                    if cat.categoryId == (self.parentCategory as NSString).integerValue {
                        for ch in cat.channels {
                            channelIds.append("\(ch.channelId)")
                        }
                        break
                    }
                    
                }
            }
            dictionary["chanels"] = channelIds.joinWithSeparator(",")
        }
        
        dictionary["first_id"] = self.firstId
        
        makeCall(Page.feeds, params: dictionary, showIndicator: false) { (response) in
            print("result arrived")
            let array = response as! NSArray
            if array.count == 0 {
                return
            }
            
            self.newFeedsArray = []
            for index in 0..<array.count {
                let item = array[index]
                let feed = Feed(fromDictionary: item as! NSDictionary)
                if self.feedType == .Country {
                    feed.image = ""
                }
                
                if index == 0 {
                    self.firstId = feed.id
                }
                self.newFeedsArray!.append(feed)
            }
            
            var paths:[NSIndexPath] = []
            for index in 0..<self.newFeedsArray!.count {
                paths.append(NSIndexPath(forRow: index, inSection: 0))
            }
            
            self.feeds.insertContentsOf(self.newFeedsArray!, at: 0)
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
            
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.Automatic)
            self.tableView.endUpdates()
            self.refreshControl.endRefreshing()
            
            self.buttonScrollUp.setTitle(" \(array.count) \(Localization.get("scroll_up_message"))", forState: .Normal)
            self.buttonScrollUp.hidden = false
            
            NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: #selector(self.hideNewFeedsButton), userInfo: nil, repeats: false)
        }
    }
    }
    func hideNewFeedsButton() {
        self.newFeedsArray?.removeAll()
        self.buttonScrollUp.hidden = true
    }
    
    
    func sourceSelected(notification: NSNotification) {
        if notification.name == "AddedGeneralNewsSource" {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: "AddedGeneralNewsSource", object: nil)
        }
        
        self.feeds.removeAll()
        self.tableView.emptyDataSetSource = self
        self.tableView.reloadData()
        self.selectType(self.button1)
    }
    
    func resetButtons() {
//        self.button1.backgroundColor = UIColor.clearColor()
//        self.button1.setTitleColor(theme_color, forState: .Normal)
//        
//        self.button2.backgroundColor = UIColor.clearColor()
//        self.button2.setTitleColor(theme_color, forState: .Normal)
        self.button1.backgroundColor = UIColor.clearColor()
        self.button1.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button1.backgroundColor = UIColor.clearColor()
        button1.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        let border1 = CALayer()
        let width1 = CGFloat(3.0)
        border1.borderColor = theme_color.CGColor
        border1.frame = CGRect(x: 0, y: button1.frame.size.height - width1, width:  button1.frame.size.width, height: button1.frame.size.height)
        
        border1.borderWidth = width1
        button1.layer.addSublayer(border1)
        button1.layer.masksToBounds = true
        
        self.button2.backgroundColor = UIColor.clearColor()
        self.button2.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button2.backgroundColor = UIColor.clearColor()
        button2.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        let border2 = CALayer()
        let width2 = CGFloat(3.0)
        border2.borderColor = theme_color.CGColor
        border2.frame = CGRect(x: 0, y: button2.frame.size.height - width2, width:  button2.frame.size.width, height: button2.frame.size.height)
        
        border2.borderWidth = width2
        button2.layer.addSublayer(border2)
        button2.layer.masksToBounds = true
    }
    
    func selectType(sender:AnyObject) {
        resetButtons()
        
        self.lastId = ""
        params.removeValueForKey("last_id")
        print ("scrolling to top")
        let button = sender as! UIButton
//        button.backgroundColor = theme_color
//        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        let border = CALayer()
        let width = CGFloat(3.0)
        border.borderColor = UIColor.whiteColor().CGColor
        border.frame = CGRect(x: 0, y: button.frame.size.height - width, width:  button.frame.size.width, height: button.frame.size.height)
        
        border.borderWidth = width
        button.layer.addSublayer(border)
        button.layer.masksToBounds = true

        self.navigationItem.title = button.titleLabel?.text
        
        switch button {
        case self.button1:
            selectedButton="1"
            topOfTable.constant=0
            searchBar.hidden=true
            params["type"] = "latest"
            feedType = .Latest
            reloadData()
        case self.button2:
            selectedButton="2"
            topOfTable.constant=44
            searchBar.hidden=false
            self.currentSource = self.source
            self.source = ""
            params["type"] = "source"
            feedType = .Source
            let items = try! Realm().objects(SavedCategory)
            if items.count == 0 {
                self.feeds.removeAll()
                self.tableView.emptyDataSetDelegate = self
                self.tableView.emptyDataSetSource = self
                self.tableView.reloadData()
            } else {
                reloadData()
            }
       default:
            feedType = .Latest
            reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let tracker = GAI.sharedInstance().trackerWithTrackingId("UA-90639520-1")
        GAI.sharedInstance().trackUncaughtExceptions = true
        tracker.set(kGAIScreenName, value: "ChannnelNewsPage")
        let eventTracker: NSObject = GAIDictionaryBuilder.createScreenView().build()
        tracker.send(eventTracker as! [NSObject : AnyObject])
//        resetButtons()
//        
//        print("selected button previously---->",selectedButton)
//        switch selectedButton {
//        case "1":
//            selectType(self.button1)
//            break
//        case "2":
//            selectType(self.button2)
//            break
//        default:
//            selectType(self.button1)
//            
//        }
        button1.mixedBackgroundColor = MixedColor(normal: 0x097f9a, night: 0x283541)
        button2.mixedBackgroundColor = MixedColor(normal: 0x097f9a, night: 0x283541)
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    
    override func scrollToTop() {
        if(showingChannels .isEqualToString("channels")){
        }else{
            if self.feeds.count > 0 {
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
            }
        }
    }
    
    func reloadData() {
        self.lastId = ""
        self.params.removeAll()
        showingChannels=""
        var channelIds:[String] = []
        let items = try! Realm().objects(SavedCategory)
        for cat in items {
            if cat.categoryId == (self.parentCategory as NSString).integerValue {
                for ch in cat.channels {
                    channelIds.append("\(ch.channelId)")
                }
                break
            }
            
        }
        
        if self.feedType == .Urgent {
            channelIds.removeAll()
            self.lastFeedType = .Urgent
            
            if channelIds.count == 0 {
                self.feeds.removeAll()
                self.tableView.emptyDataSetSource = self
                self.tableView.emptyDataSetDelegate = self
                self.tableView.reloadData()
            } else {
                self.params["type"] = "urgent"
                self.params["chanels"] = channelIds.joinWithSeparator(",")
                if self.feeds.count > 0 {
                    self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
                }
                
                fetchFeeds()
            }
        } else {
            
            if channelIds.count == 0 {
                self.feeds.removeAll()
                self.tableView.emptyDataSetSource = self
                self.tableView.emptyDataSetDelegate = self
                self.tableView.reloadData()
            } else {
                if self.feedType == .Latest {
                    self.lastId = ""
                    self.params["chanels"] = channelIds.joinWithSeparator(",")
                    if self.feeds.count > 0 {
                        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
                    }
                    
                    self.lastFeedType = self.feedType
                    fetchFeeds()
                } else if self.feedType == .Source {
                    if self.source.characters.count > 0 {
                        self.navigationItem.title = self.sourceTitle
                        self.lastId = ""
                        self.params["chanels"] = self.source
                        if self.feeds.count > 0 {
                            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
                        }
                        
                        self.lastFeedType = .Source
                        self.fetchFeeds()
                    } else {
                        showingChannels="channels"
                        var channelIds:[String] = []
                        let items = try! Realm().objects(SavedCategory)
                        for cat in items {
//                            if (cat.categoryId == 29) || (cat.categoryId == 4) {
//                                continue
//                            }
                            
                            
                            if self.parentCategory.isEmpty == true {
                                
                                for ch in cat.channels {
                                    channelIds.append("\(ch.channelId)")
                                }
                            } else {
                                if cat.categoryId == Int(self.parentCategory) {
                                    for ch in cat.channels {
                                        channelIds.append("\(ch.channelId)")
                                    }
                                }
                            }
                        }
                        
                        if channelIds.count > 0 {
                            makeCall(Page.selectedCategories, params: ["chanels":channelIds.joinWithSeparator(",")]) { (response) in
                                let array = response as! NSArray
                                self.channels.removeAll()
                                for item in array {
                                    self.channels.append(Chanel(fromDictionary: item as! NSDictionary))
                                }
                                
                                self.tableView.reloadData()
                                self.refreshControl.endRefreshing()
                                
                                
                            }
                        } else {
                            
                        }
 }
                    return
                    
                }
            }
        }
    }
    
    func fetchFeeds(showIndicator:Bool = true) {
        if(showingChannels .isEqualToString("channels")){
        }else{
        if self.lastId.characters.count > 0 {
            self.params["last_id"] = self.lastId
        }
        makeCall(Page.feeds, params: self.params, showIndicator: showIndicator, failureHandler: {
            //self.tableView.userInteractionEnabled = true
            self.scrollRequestInProgress = false
            self.refreshControl.endRefreshing()
            
            self.pagingSpinner.stopAnimating()
            self.pagingSpinner.hidden = true
            
        }) { (response) in
            //self.tableView.userInteractionEnabled = true
            print("result arrived")
            //self.requestInProgress = false
            
            self.pagingSpinner.stopAnimating()
            self.pagingSpinner.hidden = true
            
            let array = response as! NSArray
            //            if !self.searchbarHidden {
            //                self.feeds.removeAll()
            //            }
            
            if self.lastId.characters.count == 0 {
                print("removeAll")
                self.feeds.removeAll()
                for index in 0..<array.count {
                    let item = array[index]
                    let feed = Feed(fromDictionary: item as! NSDictionary)
                    if self.feedType == .Country {
                        feed.image = ""
                    }
                    self.feeds.append(feed)
                    if index == 0 {
                        // set the firstId for background fetch
                        self.firstId = feed.id
                    } else if index == (array.count - 1) {
                        self.lastId = feed.id
                    }
                }
                
                print("tableView.reloadData()")
                self.tableView.reloadData()
            } else {
                if array.count == 0 {
                    return
                }
                
                let count = self.feeds.count
                var paths:[NSIndexPath] = []
                for i in 0..<array.count {
                    paths.append(NSIndexPath(forRow: count + i, inSection: 0))
                }
                
                for index in 0..<array.count {
                    let item = array[index]
                    let feed = Feed(fromDictionary: item as! NSDictionary)
                    if self.feedType == .Country {
                        feed.image = ""
                    }
                    self.feeds.append(feed)
                    
                    if index == (array.count - 1) {
                        self.lastId = feed.id
                    }
                    //self.feeds.append(Feed(fromDictionary: item as! NSDictionary))
                }
                
                self.tableView.emptyDataSetSource = self
                self.tableView.emptyDataSetDelegate = self
                
                self.tableView.beginUpdates()
                self.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.Automatic)
                self.tableView.endUpdates()
            }
            
            self.refreshControl.endRefreshing()
            self.scrollRequestInProgress = false
            }
        }
    }
    
    var scrollRequestInProgress = false
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // check if the scroll request is in progress
        if(showingChannels .isEqualToString("channels")){
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
            
        }else{
            if self.scrollRequestInProgress == true {
                return
            }
            
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            print("offset : \(maximumOffset - currentOffset)")
            
            if maximumOffset - currentOffset <= 400 {
                print("fetching next page \(self.lastId)")
                pagingSpinner.startAnimating()
                pagingSpinner.hidden = false
                self.scrollRequestInProgress = true
                self.fetchFeeds(false)
            }
        }
    }
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return UIColor.clearColor()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: Localization.get("no_feeds"))
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "no_articles.png")
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let string = NSMutableAttributedString(string: Localization.get("title_add_source"))
        string.addAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], range: NSRange(location: 0, length: string.length))
        return string
    }
    
    func buttonBackgroundImageForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> UIImage! {
        return UIImage(named: "button_background.png")
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        self.tabBarController?.selectedIndex = 4
        //NSNotificationCenter.defaultCenter().postNotificationName("Sports", object: nil)

    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(showingChannels .isEqualToString("channels")){
            if(searchActive){
                return self.searchResults.count

            }
            return self.channels.count
                
            
        }else{
            print("numberOfRowsInSection \(self.feeds.count)")
            return self.feeds.count
        }
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(showingChannels .isEqualToString("channels")){
            return 70
        }else{
            return UITableViewAutomaticDimension

        }
    }
    
    @IBAction func selectSources(sender: AnyObject) {
        let vc = Utils.getViewController("AppSettingsViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
            if(showingChannels .isEqualToString("channels")){
                searchBar.resignFirstResponder()

                topOfTable.constant=0
                searchBar.hidden=true
                if(searchActive){
                showingChannels=""
                //self.selectedChannel?(channel:self.channels[indexPath.row])
                let channel:Chanel = self.searchResults[indexPath.row]
                
                self.navigationItem.title = channel.Title
                self.source = channel.id
                self.currentSource = channel.id
                self.sourceTitle = channel.title
                self.lastId = ""
                self.params["chanels"] = channel.id
                if self.feeds.count > 0 {
                    self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
                }
                self.lastFeedType = .Source
                self.fetchFeeds()
                
                }else{
                        showingChannels=""
                        //self.selectedChannel?(channel:self.channels[indexPath.row])
                        let channel:Chanel = self.channels[indexPath.row]
                        
                        self.navigationItem.title = channel.Title
                        self.source = channel.id
                        self.currentSource = channel.id
                        self.sourceTitle = channel.title
                        self.lastId = ""
                        self.params["chanels"] = channel.id
                        if self.feeds.count > 0 {
                            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
                        }
                        self.lastFeedType = .Source
                        self.fetchFeeds()
                        
                    }
                }
                else{
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let feed = self.feeds[indexPath.row]
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject("Readed", forKey:(feed.id))
                    
                makeCallWithOutProgess(Page.newsVisit, params: ["feed_id":feed.id]) { (response) in
                    print(response)
                }
                
        if feed.type == "news" {
            let vc:NewsDetailsViewController = Utils.getViewController("NewsDetailsViewController") as! NewsDetailsViewController
            vc.feed = feed
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if !feed.mp4.isEmpty {
                let vc:JWPlayerViewController = Utils.getViewController("JWPlayerViewController") as! JWPlayerViewController
                vc.file = feed.mp4
                vc.screenTitle = feed.Title
                self.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            } else {
                let vc:BrowserViewController = Utils.getViewController("BrowserViewController") as! BrowserViewController
                vc.url = feed.link
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
                let indexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
    }
    }
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject: AnyObject]) {
        print(results)
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        print("sharer NSError")
        print(error.description)
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        print("sharerDidCancel")
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(showingChannels .isEqualToString("channels")){
            if(searchActive){

            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine

            let cell:CategoryTableViewCell =  self.tableView.dequeueReusableCellWithIdentifier("Channelcell") as! CategoryTableViewCell
            cell.separatorInset = UIEdgeInsetsZero;

            let cat:Chanel = self.searchResults[indexPath.row]
            
            cell.labelTitle.text = cat.Title
            if let imageURL = NSURL(string:cat.image) {
                cell.imageViewCategory.setImageWithURL(imageURL)
            }
            
            return cell
            
            
            }else
                {
                    
                    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                    
                    let cell:CategoryTableViewCell =  self.tableView.dequeueReusableCellWithIdentifier("Channelcell") as! CategoryTableViewCell
                    cell.separatorInset = UIEdgeInsetsZero;
                    
                    let cat:Chanel = self.channels[indexPath.row]
                    
                    cell.labelTitle.text = cat.Title
                    if let imageURL = NSURL(string:cat.image) {
                        cell.imageViewCategory.setImageWithURL(imageURL)
                    }
                    
                    return cell
                    
                    
                }
        }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        let feed:Feed = self.feeds[indexPath.row]
        if feed.type == "add" {
            
            let cell:AdTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell_ad") as! AdTableViewCell
            cell.displayFeed(feed)
            
            cell.showAction = {
                let vc = FeedShareViewController(nibName: "FeedShareViewController", bundle: nil)
                vc.delegate = self
                vc.feed = feed
                self.presentPopupViewController(vc, animationType: MJPopupViewAnimationSlideBottomTop)
            }
            
            return cell
            
        } else if feed.type == "double_add" || feed.type=="double_video" {
            
            let cell:GoogleAdTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell_gad") as! GoogleAdTableViewCell
            cell.showAction = {
                let vc = FeedShareViewController(nibName: "FeedShareViewController", bundle: nil)
                vc.delegate = self
                vc.feed = feed
                self.presentPopupViewController(vc, animationType: MJPopupViewAnimationSlideBottomTop)
            }
            //            cell.displayFeed(feed)
            //
            //            cell.showAction = {
            //                let vc = FeedShareViewController(nibName: "FeedShareViewController", bundle: nil)
            //                vc.delegate = self
            // vc.feed = feed
            //self.presentPopupViewController(vc, animationType: MJPopupViewAnimationSlideBottomTop)
            // }
            //            cell.bannerView.adUnitID = "ca-app-pub-2235475769630197/2004478063"
            //            cell.bannerView.rootViewController = self
            //            cell.bannerView.loadRequest(GADRequest())
            cell.bannerView.adUnitID = feed.title
            cell.bannerView.rootViewController = self
            cell.bannerView.loadRequest(DFPRequest())
            return cell
            
        } else {
            
            var cellId = "cell"
            
            if feed.isUrgent == 1 {
                if feed.image.characters.count == 0 {
                    cellId = "urgentcelltext"
                } else {
                    cellId = "urgentcell"
                }
            } else {
                if (feed.image.characters.count == 0) || (feed.titleOnly == true) {
                    cellId = "celltext"
                }
            }
            
            let cell:NewsItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellId) as! NewsItemTableViewCell
            cell.selectionStyle = .None
            //cell.showFeed(feed)
            cell.showFeed(feed,cat: "list")

            if feed.id == "0" {
                cell.backgroundColor = ad_color
                cell.contentView.backgroundColor = ad_color
            }
            cell.showAction = {
                let vc = FeedShareViewController(nibName: "FeedShareViewController", bundle: nil)
                vc.delegate = self
                vc.feed = feed
                self.presentPopupViewController(vc, animationType: MJPopupViewAnimationSlideBottomTop)
            }
            cell.selectChannel = {
                let vc:ChannelDetailsViewController = Utils.getViewController("ChannelDetailsViewController") as! ChannelDetailsViewController
                vc.channel = feed.chanel!
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            cell.layoutIfNeeded()
            return cell
        }
    }
    }
}
