//
//  SettingsViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 19/07/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import RealmSwift
import Social

class SettingsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var categories:[AppCateogry] = []
    var channels:[Chanel] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        self.button1.setTitle(Localization.get("settings_all"), forState: .Normal)
        self.button2.setTitle(Localization.get("settings_my_sources"), forState: .Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.button1.layer.borderColor = theme_color.CGColor
        self.button1.layer.borderWidth = 1
        self.button1.setTitleColor(theme_color, forState: .Normal)
        self.button1.addTarget(self, action: #selector(selectType), forControlEvents: .TouchUpInside)
        
        self.button2.layer.borderColor = theme_color.CGColor
        self.button2.layer.borderWidth = 1
        self.button2.setTitleColor(theme_color, forState: .Normal)
        self.button2.addTarget(self, action: #selector(selectType), forControlEvents: .TouchUpInside)
        
        self.navigationItem.title = Localization.get("title_select_sources")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings_edit_sources.png"), style: .Done, target: self, action: #selector(showSettings))
        
        self.tableView.registerNib(UINib(nibName: "ChannelTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.rowHeight = 50
        
        //self.navigationItem.title = Localization.get("title_settings")
        self.collectionView.registerNib(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")

        self.collectionView.hidden = false
        self.tableView.hidden = true
        
        self.collectionView.backgroundColor = UIColor.clearColor()
        
        makeCall(Page.categories, params: [:]) { (response) in
            self.selectType(self.button1)

            let array = response as! NSArray
            self.categories.removeAll()
            for item in array {
                self.categories.append(AppCateogry(fromDictionary: item as! NSDictionary))
            }
            self.collectionView.reloadData()
        }
        
    }
    
    func resetButtons() {
        self.button1.backgroundColor = UIColor.clearColor()
        self.button1.setTitleColor(theme_color, forState: .Normal)
        
        self.button2.backgroundColor = UIColor.clearColor()
        self.button2.setTitleColor(theme_color, forState: .Normal)
    }
    
    func showSettings() {
        let vc = Utils.getViewController("AppSettingsViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func selectType(sender: AnyObject) {
        resetButtons()
        
        let button = sender as! UIButton
        button.backgroundColor = theme_color
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        if button == self.button1 {
            self.collectionView.hidden = false
            self.tableView.hidden = true
        } else if button == self.button2 {
            self.channels.removeAll()

            self.collectionView.hidden = true
            self.tableView.hidden = false
            
            var channelIds:[String] = []
            let items = try! Realm().objects(SavedCategory)
            for cat in items {
                for ch in cat.channels {
                    channelIds.append("\(ch.channelId)")
                }
            }

            if channelIds.isEmpty == true {
                self.selectType(self.button1)
                showErrorAlert("error_no_channels_subscribed")
            } else {
                makeCall(Page.selectedCategories, params: ["chanels":channelIds.joinWithSeparator(",")]) { (response) in
                    let array = response as! NSArray
                    self.channels.removeAll()
                    for item in array {
                        let ch = Chanel(fromDictionary: item as! NSDictionary)
                        ch.selected = true
                        self.channels.append(ch)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.channels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ChannelTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! ChannelTableViewCell
        let channel = channels[indexPath.row]
        cell.labelTitle.text = channel.Title
        if let imageURL = NSURL(string:channel.image) {
            cell.imageViewChannel.setImageWithURL(imageURL)
        }
    
        
        cell.buttonADd.setBackgroundImage(UIImage(named: "profile_unfollow.png"), forState: .Normal)
        cell.buttonADd.setTitle("", forState: .Normal)
//        cell.buttonADd.setTitle("\u{2714}", forState: .Normal)
//        cell.buttonADd.setTitle(Localization.get("unfollow"), forState: .Normal)
        cell.buttonADd.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cell.buttonADd.backgroundColor = theme_color
        cell.channelToggledCompleted = {
            
            let alert:UIAlertController = UIAlertController(title: nil, message: Localization.get("message_channel_unfollow"), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: Localization.get("yes"), style: .Default, handler: { (alert) in
                let realm = try! Realm()
                try! realm.write {
                    let items = try! Realm().objects(SavedCategory)
                    for cat in items {
                        for index in 0..<cat.channels.count {
                            let ch = cat.channels[index]
                            if ch.channelId == Int(channel.id) {
                                cat.channels.removeAtIndex(index)
                                break
                            }
                        }
                        
                        if cat.channels.count == 0 {
                            realm.delete(cat)
                        }
                    }
                }
                
                self.channels.removeAtIndex(indexPath.row)
                self.tableView.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: Localization.get("no"), style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        cell.selectionStyle = .None
        
        return cell
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSMutableAttributedString(string: Localization.get("empty_no_channels_in_category"))
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        /*
        let vc:ChannelDetailsViewController = Utils.getViewController("ChannelDetailsViewController") as! ChannelDetailsViewController
        vc.channel = self.channels[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        */
        
        let vc:ChannelsViewController = Utils.getViewController("ChannelsViewController") as! ChannelsViewController
        vc.category = self.categories[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CategoryCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CategoryCollectionViewCell
        let category = self.categories[indexPath.row]
        
        cell.labelTitle.text = category.Title
        if let imageURL = NSURL(string:category.image) {
            cell.imageViewCategory.setImageWithURL(imageURL)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((self.view.frame.width / 3) - 30, 105)
    }

}
