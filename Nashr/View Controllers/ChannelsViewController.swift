//
//  ChannelsViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 31/07/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet

class ChannelsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    //@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var category:AppCateogry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = self.category!.Title
        self.tableView.registerNib(UINib(nibName: "ChannelTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.rowHeight = 50
        
//        self.collectionView.registerNib(UINib(nibName: "ChannelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        getSelectedChannels()
    }
    
    func getSelectedChannels() {
        let items = try! Realm().objects(SavedCategory)
        var item:SavedCategory?
        for cat in items {
            if cat.categoryId == (self.category!.id as NSString).integerValue {
                item = cat
                break
            }
        }
        
        if item != nil {
            for channelId in item!.channels {
                toggleChannel("\(channelId.channelId)")
            }
        }
        
        self.tableView.reloadData()
    }
    
    func toggleChannel(channelId:String) {
        for channel in (self.category?.chanels)! {
            if channel.id == channelId {
                channel.selected = true
                break
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    func saveStatus() {
        let realm = try! Realm()
        try! realm.write {
            
            var savedCategory:SavedCategory? = nil
            let items = try! Realm().objects(SavedCategory)
            for cat in items {
                if cat.categoryId == (self.category!.id as NSString).integerValue {
                    savedCategory = cat
                    break
                }
            }
            
            if savedCategory == nil {
                savedCategory = SavedCategory()
                savedCategory!.categoryId = (self.category!.id as NSString).integerValue
                realm.add(savedCategory!)
            }
            
            savedCategory?.channels.removeAll()
            for channel in self.category!.chanels {
                if channel.selected {
                    let ch = SavedChannel()
                    ch.channelId = (channel.id as NSString).integerValue
                    savedCategory!.channels.append(ch)
                }
            }
            
            if savedCategory!.channels.count == 0 {
                realm.delete(savedCategory!)
            }
        }
        
        let items = try! Realm().objects(SavedCategory)
        if items.count == 0 {
            NSNotificationCenter.defaultCenter().postNotificationName("NoNewsSource", object: nil)
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("AddedGeneralNewsSource", object: nil)
            let items = try! Realm().objects(SavedCategory)
            for cat in items {
                if cat.categoryId == 29 {
                    if cat.channels.count == 0 {
                        NSNotificationCenter.defaultCenter().postNotificationName("NoEconomyNewsSource", object: nil)
                    } else {
                        NSNotificationCenter.defaultCenter().postNotificationName("AddedEconomyNewsSource", object: nil)
                    }
                    break
                }
            }
            
            for cat in items {
                if cat.categoryId == 4 {
                    if cat.channels.count == 0 {
                        NSNotificationCenter.defaultCenter().postNotificationName("NoSportsNewsSource", object: nil)
                    } else {
                        NSNotificationCenter.defaultCenter().postNotificationName("AddSportsNewsSource", object: nil)
                    }
                    break
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSMutableAttributedString(string: Localization.get("empty_no_channels_in_category"))
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.category!.chanels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ChannelTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! ChannelTableViewCell
        let channel = self.category!.chanels[indexPath.row]
        cell.labelTitle.text = channel.Title
        if let imageURL = NSURL(string:channel.image) {
            cell.imageViewChannel.setImageWithURL(imageURL)
        }
        if channel.selected == true {
            cell.buttonADd.setBackgroundImage(UIImage(named: "profile_unfollow.png"), forState: .Normal)
            cell.buttonADd.setTitle("", forState: .Normal)
//            cell.buttonADd.setTitle(Localization.get("unfollow"), forState: .Normal)
//            cell.buttonADd.setTitle("\u{2714}", forState: .Normal)
            cell.buttonADd.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            cell.buttonADd.backgroundColor = theme_color
        } else {
            cell.buttonADd.setTitle(Localization.get("follow"), forState: .Normal)
            cell.buttonADd.setTitleColor(theme_color, forState: .Normal)
            cell.buttonADd.backgroundColor = UIColor.clearColor()
            cell.buttonADd.setBackgroundImage(nil, forState: .Normal)
        }
        
        cell.channelToggledCompleted = {
            if channel.selected == true {
                channel.selected = false
                cell.buttonADd.setBackgroundImage(nil, forState: .Normal)
                cell.buttonADd.setTitle(Localization.get("follow"), forState: .Normal)
                cell.buttonADd.setTitleColor(theme_color, forState: .Normal)
                cell.buttonADd.backgroundColor = UIColor.clearColor()
                self.makeCall(Page.followChannel, params: ["chanel_id":channel.id, "type":"add"], showIndicator:false, completionHandler: { (response) in
                    
                })
            } else {
                channel.selected = true
                cell.buttonADd.setTitle("", forState: .Normal)
                cell.buttonADd.setBackgroundImage(UIImage(named: "profile_unfollow.png"), forState: .Normal)
//                cell.buttonADd.setTitle("\u{2714}", forState: .Normal)
//                cell.buttonADd.setTitle(Localization.get("unfollow"), forState: .Normal)
                cell.buttonADd.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                cell.buttonADd.backgroundColor = theme_color
                self.makeCall(Page.followChannel, params: ["chanel_id":channel.id, "type":"remove"], showIndicator:false, completionHandler: { (response) in
                    
                })
            }
            
            self.saveStatus()
            self.updateChannelsList()
        }
        
        cell.selectionStyle = .None
        
        return cell
    }
    
    
    func updateChannelsList() {
        var channelIds:[String] = []
        let items = try! Realm().objects(SavedCategory)
        for cat in items {
            for ch in cat.channels {
                channelIds.append("\(ch.channelId)")
            }
        }
        
        if (Settings.deviceToken != nil) && (channelIds.count > 0) {
            let status:Bool = (Settings.urgentNewsNotification == nil) ? true : Settings.urgentNewsNotification!
            self.makeCall(Page.tokenRegister, params: ["device_token":Settings.deviceToken!,"chanels":channelIds.joinWithSeparator(","), "status":(status == true) ? "true" : "false"], completionHandler: { (response) in
                
            })
        }
    }
    
    /*
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc:ChannelDetailsViewController = Utils.getViewController("ChannelDetailsViewController") as! ChannelDetailsViewController
        vc.channel = self.category?.chanels[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:ChannelCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ChannelCollectionViewCell
        let channel = self.category?.chanels[indexPath.row]
        cell.labelTitle.text = channel!.Title
        if let imageURL = NSURL(string:channel!.image) {
            cell.imageViewChannel.setImageWithURL(imageURL)
        }
        
        if channel?.selected == true {
            //cell.buttonADd.setBackgroundImage(UIImage(named: "profile_unfollow.png"), forState: .Normal)
            cell.buttonADd.setTitle(Localization.get("unfollow"), forState: .Normal)
        } else {
            cell.buttonADd.setTitle(Localization.get("follow"), forState: .Normal)
            //cell.buttonADd.setBackgroundImage(nil, forState: .Normal)
        }
        
        cell.channelToggledCompleted = {
            if channel?.selected == true {
                channel?.selected = false
                cell.buttonADd.setTitle(Localization.get("follow"), forState: .Normal)

                //cell.buttonADd.setTitle(Localization.get("channel_add"), forState: .Normal)
                cell.buttonADd.setBackgroundImage(nil, forState: .Normal)
            } else {
                channel?.selected = true
                //cell.buttonADd.setBackgroundImage(UIImage(named: "profile_unfollow.png"), forState: .Normal)
                cell.buttonADd.setTitle(Localization.get("unfollow"), forState: .Normal)
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.category?.chanels.count)!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((self.view.frame.width / 3) - 30, 105)
    }
    */

}
