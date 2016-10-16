//
//  ChannelDetailsViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 03/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import RealmSwift

class ChannelDetailsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewFollowed: UIImageView!
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var requestInProgress = false
    
    var channel:Chanel?
    var pageIndex = 1
    
    var refreshControl:UIRefreshControl = UIRefreshControl()
    var feeds:[Feed] = []
    let pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.channel?.Title
        pagingSpinner.color = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        pagingSpinner.hidesWhenStopped = true
        pagingSpinner.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44);
        tableView.tableFooterView = pagingSpinner

        self.tableView.registerNib(UINib(nibName: "UrgentNewsItemTableViewCell", bundle: nil), forCellReuseIdentifier: "urgentcell")
        self.tableView.registerNib(UINib(nibName: "UrgentNewsTextItemTableViewCell", bundle: nil), forCellReuseIdentifier: "urgentcelltext")
        self.tableView.registerNib(UINib(nibName: "NewsItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.registerNib(UINib(nibName: "NewsItemTextTableViewCell", bundle: nil), forCellReuseIdentifier: "celltext")
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.backgroundColor = UIColor(red:0.874,  green:0.875,  blue:0.874, alpha:1)
        
        self.refreshControl.addTarget(self, action: #selector(reloadData), forControlEvents: .ValueChanged)
        self.refreshControl.backgroundColor = UIColor(red:0.874,  green:0.875,  blue:0.874, alpha:1)
        
        self.tableView.addSubview(self.refreshControl)
        
        if let imageURL = NSURL(string:self.channel!.image) {
            self.imageViewIcon.setImageWithURL(imageURL)
        }
        
        if let imageURL = NSURL(string:self.channel!.coverImage) {
            self.imageViewBackground.setImageWithURL(imageURL)
        }
        
        self.imageViewIcon.layer.cornerRadius = 10
        self.imageViewIcon.clipsToBounds = true
        
        self.labelTitle.text = self.channel!.Title
        self.labelCount.text = "\(self.channel!.count)"
        
        self.imageViewFollowed.hidden = true

        let items = try! Realm().objects(SavedCategory)
        for cat in items {
            for channel in cat.channels {
                if Int((self.channel?.id)!) == channel.channelId {
                    self.imageViewFollowed.hidden = false
                    break;
                }
            }
        }
        
        reloadData()
    }
    
    override func closePopup(vc: UIViewController) {
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationSlideBottomTop)
    }
    
    func reloadData(showIndicator:Bool = true) {
        if self.requestInProgress == true {
            return
        }
        
        self.requestInProgress = true
        var params:[String:AnyObject] = [:]
        params["chanels"] = self.channel!.id
        params["page"] = pageIndex
        makeCall(Page.feeds, params: params, showIndicator: showIndicator) { (response) in
            print("result arrived")
            
            self.pagingSpinner.stopAnimating()
            self.pagingSpinner.hidden = true
            
            let array = response as! NSArray

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
                
                self.tableView.beginUpdates()
                self.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.Automatic)
                self.tableView.endUpdates()
            }
            
            self.refreshControl.endRefreshing()
            self.requestInProgress = false
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feeds.count
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        print("offset : \(maximumOffset - currentOffset)")
        
        if maximumOffset - currentOffset <= 800 {
            print("fetching next page \(self.pageIndex)")
            pagingSpinner.startAnimating()
            pagingSpinner.hidden = false
            pageIndex += 1
            self.reloadData(false)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let feed = self.feeds[indexPath.row]
//        if feed.image.characters.count == 0 {
//            return 150
//        } else {
//            return 309
//        }
        return UITableViewAutomaticDimension
    }
    
    @IBAction func selectSources(sender: AnyObject) {
        let vc = Utils.getViewController("CategoryListViewController")
        presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
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
        cell.layoutIfNeeded()
        return cell

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
