//
//  SearchViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 02/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class SearchViewController: SearchBaseViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl:UIRefreshControl = UIRefreshControl()
    var feeds:[Feed] = []
    var dictionary:NSDictionary?
    var searchParams:[String:AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 44.0
        self.navigationItem.title = Localization.get("search")
        self.tableView.registerNib(UINib(nibName: "UrgentNewsItemTableViewCell", bundle: nil), forCellReuseIdentifier: "urgentcell")
        self.tableView.registerNib(UINib(nibName: "UrgentNewsTextItemTableViewCell", bundle: nil), forCellReuseIdentifier: "urgentcelltext")
        self.tableView.registerNib(UINib(nibName: "NewsItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.registerNib(UINib(nibName: "NewsItemTextTableViewCell", bundle: nil), forCellReuseIdentifier: "celltext")
        self.tableView.backgroundColor = UIColor(red:0.874,  green:0.875,  blue:0.874, alpha:1)
        self.tableView.rowHeight = 229
        self.dictionary = (UIApplication.sharedApplication().delegate as! AppDelegate).dictionary

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(self.search))
        
        self.view.bringSubviewToFront(self.searchBar)
        self.searchbarHidden = true
        self.search()
    }
    
    override func searchWithText(text:String) {
        self.navigationItem.title = text
        self.searchParams!["search"] = text
        makeCall(Page.feeds, params: self.searchParams!) { (response) in
            let array = response as! NSArray
            self.feeds.removeAll()
            for item in array {
                self.feeds.append(Feed(fromDictionary: item as! NSDictionary))
            }
            
            self.tableView.emptyDataSetSource = self
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: Localization.get("search_empty_feeds"))
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc:NewsDetailsViewController = Utils.getViewController("NewsDetailsViewController") as! NewsDetailsViewController
        vc.feed = self.feeds[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feeds.count
    }    

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
        cell.layoutIfNeeded()
        return cell
    }

}
