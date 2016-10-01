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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "News"
        self.tableView.registerNib(UINib(nibName: "NewsItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.rowHeight = 229
        self.tableView.backgroundColor = UIColor.clearColor()
        
        makeCall(Page.settings, params: [:]) { (response) in
            self.dictionary = response as! NSDictionary
        }
        
        reloadData()
    }
    
    func reloadData() {
//        makeCall(Page.feeds, params: self.searchParams!) { (response) in
//            let array = response as! NSArray
//            self.feeds.removeAll()
//            for item in array {
//                self.feeds.append(Feed(fromDictionary: item as! NSDictionary))
//            }
//            
//            self.tableView.emptyDataSetSource = self
//            self.tableView.reloadData()
//            self.refreshControl.endRefreshing()
//        }
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
        let feed = self.feeds[indexPath.row]
        if feed.image.characters.count == 0 {
            return 160
        } else {
            return 355
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:NewsItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! NewsItemTableViewCell
        cell.selectionStyle = .None
        let feed:Feed = self.feeds[indexPath.row]
        cell.showFeed(feed)
        cell.showAction = {
            let vc = FeedShareViewController(nibName: "FeedShareViewController", bundle: nil)
            vc.delegate = self
            vc.feed = feed
            vc.dictionary = self.dictionary
            self.presentPopupViewController(vc, animationType: MJPopupViewAnimationSlideBottomTop)
        }
        cell.selectChannel = {
            let vc:ChannelDetailsViewController = Utils.getViewController("ChannelDetailsViewController") as! ChannelDetailsViewController
            vc.channel = feed.chanel!
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        return cell
    }

}
