//
//  SportsViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 19/07/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

class SportsViewController: BaseViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonContainer: UIView!
    var feedType:FeedType = .Latest
    var pageIndex = 1
    var params:[String:AnyObject] = [:]
    var source = ""
    var requestInProgress = false
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    var refreshControl:UIRefreshControl = UIRefreshControl()
    var feeds:[Feed] = []
    
    @IBAction func searchFeeds(sender: AnyObject) {
        let vc:SearchViewController = Utils.getViewController("SearchViewController") as! SearchViewController
        vc.searchParams = self.params
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    override func cancelSearch() {
        var sender:UIButton? = nil
        self.params.removeAll()
        if feedType == .Latest {
            sender = self.button1
        } else if self.feedType == .Source {
            self.reloadData()
            return
        }
        
        selectType(sender!)
    }
    
    override func searchWithText(text: String) {
        self.params.removeAll()
        if feedType == .Latest {
            params["type"] = "latest"
        } else if self.feedType == .Source {
            params["type"] = "source"
        }
        
        self.pageIndex = 1
        if text.characters.count > 0 {
            params["search"] = text
        }
        self.fetchFeeds(true)
    }
    */
    
    let pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonContainer.layer.cornerRadius = 5
        self.buttonContainer.clipsToBounds = true
        self.buttonContainer.layer.borderColor = theme_color.CGColor
        self.buttonContainer.layer.borderWidth = 1
        
        
        pagingSpinner.color = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        pagingSpinner.hidesWhenStopped = true
        pagingSpinner.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44);
        tableView.tableFooterView = pagingSpinner
        
        self.button1.layer.borderColor = theme_color.CGColor
        self.button1.layer.borderWidth = 1
        self.button1.setTitleColor(theme_color, forState: .Normal)
        self.button1.addTarget(self, action: #selector(selectType), forControlEvents: .TouchUpInside)
        
        self.button2.layer.borderColor = theme_color.CGColor
        self.button2.layer.borderWidth = 1
        self.button2.setTitleColor(theme_color, forState: .Normal)
        self.button2.addTarget(self, action: #selector(selectType), forControlEvents: .TouchUpInside)
        
        self.button1.setTitle(Localization.get("latest"), forState: .Normal)
        self.button2.setTitle(Localization.get("source"), forState: .Normal)
        
        self.navigationItem.title = Localization.get("title_sports")
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.tableView.backgroundColor = UIColor(red:0.874,  green:0.875,  blue:0.874, alpha:1)

        self.tableView.registerNib(UINib(nibName: "UrgentNewsItemTableViewCell", bundle: nil), forCellReuseIdentifier: "urgentcell")
        self.tableView.registerNib(UINib(nibName: "UrgentNewsTextItemTableViewCell", bundle: nil), forCellReuseIdentifier: "urgentcelltext")
        self.tableView.registerNib(UINib(nibName: "NewsItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.registerNib(UINib(nibName: "NewsItemTextTableViewCell", bundle: nil), forCellReuseIdentifier: "celltext")

        //self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44

        self.refreshControl.addTarget(self, action: #selector(reloadData), forControlEvents: .ValueChanged)
        self.refreshControl.backgroundColor = UIColor(red:0.874,  green:0.875,  blue:0.874, alpha:1)
        
        self.tableView.addSubview(self.refreshControl)
        resetButtons()
        
        self.selectType(self.button1)
        let count = self.getChannelCount()
        if count == 0 {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sourceSelected), name: "AddSportsNewsSource", object: nil)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(sourceSelected), name: "NoSportsNewsSource", object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadData), name: UIApplicationDidBecomeActiveNotification, object: nil)

    }
    
    func getChannelCount() -> Int {
        var count = 0
        let items = try! Realm().objects(SavedCategory)
        for cat in items {
            if cat.categoryId == 4 {
                count = cat.channels.count
                break
            }
        }
        
        return count
    }
    
    
    func sourceSelected(notification: NSNotification) {
        if notification.name == "AddSportsNewsSource" {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: "AddSportsNewsSource", object: nil)
        }
        
        self.feeds.removeAll()
        self.tableView.emptyDataSetSource = self
        self.tableView.reloadData()
        self.selectType(self.button1)
    }
    
    
    func resetButtons() {
        self.button1.backgroundColor = UIColor.clearColor()
        self.button1.setTitleColor(theme_color, forState: .Normal)
        
        self.button2.backgroundColor = UIColor.clearColor()
        self.button2.setTitleColor(theme_color, forState: .Normal)
    }
    
    func fetchFeeds(showIndicator:Bool = true) {
        if self.requestInProgress == true {
            return
        }
//        self.params["start"] = (pageIndex * 10)
//        self.params["count"] = 10
        
        self.requestInProgress = true
        self.params["page"] = self.pageIndex
        makeCall(Page.feeds, params: self.params, showIndicator: showIndicator) { (response) in
            print("result arrived")
            
            self.pagingSpinner.stopAnimating()
            self.pagingSpinner.hidden = true

            let array = response as! NSArray
//            if !self.searchbarHidden {
//                self.feeds.removeAll()
//            }
//            
            
            if self.pageIndex == 1 {
                self.feeds.removeAll()
                for item in array {
                    self.feeds.append(Feed(fromDictionary: item as! NSDictionary))
                }
                
                self.tableView.contentOffset = CGPointMake(0, 0)
                self.tableView.reloadData()
                
            } else {
                
                let count = self.feeds.count
                var paths:[NSIndexPath] = []
                for i in 0..<array.count {
                    paths.append(NSIndexPath(forRow: count + i, inSection: 0))
                }
                
                for item in array {
                    self.feeds.append(Feed(fromDictionary: item as! NSDictionary))
                }
                
                self.tableView.emptyDataSetSource = self
                self.tableView.emptyDataSetDelegate = self
                
                self.tableView.beginUpdates()
                self.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.Automatic)
                self.tableView.endUpdates()
            }
            
            self.refreshControl.endRefreshing()
            self.requestInProgress = false

        }
    }
    
    override func scrollToTop() {
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
    }

    @IBAction func selectSources(sender: AnyObject) {
        let vc = Utils.getViewController("AppSettingsViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func selectType(sender: AnyObject) {
        resetButtons()
        let button = sender as! UIButton
        button.backgroundColor = theme_color
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.navigationItem.title = button.titleLabel?.text
        
        let count = self.getChannelCount()
        if count == 0 {
            self.feeds.removeAll()
            self.tableView.emptyDataSetDelegate = self
            self.tableView.emptyDataSetSource = self
            self.tableView.reloadData()
        } else {
            switch button {
            case self.button1:
                feedType = .Latest
                reloadData()
            case self.button2:
                self.source = ""
                feedType = .Source
                reloadData()
            default:
                feedType = .Latest
            }
        }
    }
    
    func reloadData() {
        self.params.removeAll()
        if self.feedType == .Source {
            if self.source.characters.count > 0 {
                self.pageIndex = 1
                self.params["chanels"] = self.source
                self.feeds.removeAll()
                self.fetchFeeds()
            } else {
                let vc:SelectSourceCategoryViewController = SelectSourceCategoryViewController(nibName: "SelectSourceCategoryViewController", bundle: nil)
                vc.parentCategory = "4"
                vc.cancel = {
                    self.resetButtons()
                    let button:UIButton? = self.button1
                    button!.backgroundColor = theme_color
                    button!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    self.navigationItem.title = button!.titleLabel?.text
                }
                vc.selectedChannel = {channel in
                    self.navigationItem.title = channel.Title
                    self.pageIndex = 1
                    self.params["chanels"] = channel.id
                    self.source = channel.id
                    print ("scrolling to top")
                    if self.feeds.count > 0 {
                        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
                    }
                    
                    self.fetchFeeds()
                }
                vc.delegate = self
                self.presentPopupViewController(vc, animationType: MJPopupViewAnimationSlideBottomTop)
            }
            return
        } else if self.feedType == .Latest {
            var channelIds:[String] = []
            let items = try! Realm().objects(SavedCategory)
            for cat in items {
                if cat.categoryId == 4 {
                    for ch in cat.channels {
                        channelIds.append("\(ch.channelId)")
                    }
                    break
                }
            }
            print ("scrolling to top")
            if self.feeds.count > 0 {
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
            }
            
            self.params["chanels"] = channelIds.joinWithSeparator(",")
        }
        pageIndex = 1
        self.fetchFeeds()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //        let feed = self.feeds[indexPath.row]
        //        if feed.image.characters.count == 0 {
        //            return UITableViewAutomaticDimension
        //        } else {
        //            feed.Title.si
        //            return 140 + feed.Title.heightWithConstrainedWidth(self.view.frame.size.width)
        //        }
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 800 {
            pagingSpinner.startAnimating()
            pagingSpinner.hidden = false
            
            pageIndex += 1
            self.fetchFeeds(false)
        }
    }

    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: Localization.get("no_feeds"))
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "no_articles.png")
    }
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        return NSAttributedString(string: Localization.get("title_add_source"))
    }
    
    func buttonBackgroundImageForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> UIImage! {
        return UIImage(named: "button_background.png")
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        self.tabBarController?.selectedIndex = 4
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feeds.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc:NewsDetailsViewController = Utils.getViewController("NewsDetailsViewController") as! NewsDetailsViewController
        vc.feed = self.feeds[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let feed:Feed = self.feeds[indexPath.row]
        var cellId = "cell"
        if feed.isUrgent == 1 {
            if feed.image.characters.count == 0 {
                cellId = "urgentcelltext"
            } else {
                cellId = "urgentcell"
            }
        } else {
            if feed.image.characters.count == 0 {
                cellId = "celltext"
            }
        }
        
        let cell:NewsItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellId) as! NewsItemTableViewCell
        cell.selectionStyle = .None
        cell.showFeed(feed)
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
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()

        return cell

    }


}
