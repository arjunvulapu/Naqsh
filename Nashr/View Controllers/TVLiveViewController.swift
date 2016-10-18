//
//  TVLiveViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 19/07/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import XCDYouTubeKit

class TVLiveViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var buttonContainer: UIView!
    var categoryId:String?
    var cateogries:[TVLiveLinkCategory] = []
    var links:[Tv] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedCategory = 0
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonContainer.layer.cornerRadius = 5
        self.buttonContainer.clipsToBounds = true
        self.buttonContainer.layer.borderColor = theme_color.CGColor
        self.buttonContainer.layer.borderWidth = 1
        
        
        self.navigationItem.title = Localization.get("title_tv_live")
        self.collectionView.registerNib(UINib(nibName: "TVLinkCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings_edit_sources.png"), style: .Done, target: self, action: #selector(showSettings))

        self.button1.setTitle("", forState: .Normal)
        self.button2.setTitle("", forState: .Normal)
        self.button3.setTitle("", forState: .Normal)
        self.button4.setTitle("", forState: .Normal)
        
        self.button1.layer.borderColor = theme_color.CGColor
        self.button1.layer.borderWidth = 1
        self.button1.setTitleColor(theme_color, forState: .Normal)
        self.button1.addTarget(self, action: #selector(selectType), forControlEvents: .TouchUpInside)
        
        self.button2.layer.borderColor = theme_color.CGColor
        self.button2.layer.borderWidth = 1
        self.button2.setTitleColor(theme_color, forState: .Normal)
        self.button2.addTarget(self, action: #selector(selectType), forControlEvents: .TouchUpInside)
        
        self.button3.layer.borderColor = theme_color.CGColor
        self.button3.layer.borderWidth = 1
        self.button3.setTitleColor(theme_color, forState: .Normal)
        self.button3.addTarget(self, action: #selector(selectType), forControlEvents: .TouchUpInside)
        
        self.button4.layer.borderColor = theme_color.CGColor
        self.button4.layer.borderWidth = 1
        self.button4.setTitleColor(theme_color, forState: .Normal)
        self.button4.addTarget(self, action: #selector(selectType), forControlEvents: .TouchUpInside)
        
        makeCall(Page.tvLinkFull, params: [:]) { (response) in
            let array = response as! NSArray
            self.cateogries.removeAll()
            for (index, item) in array.enumerate() {
                let cat:TVLiveLinkCategory = TVLiveLinkCategory(fromDictionary: item as! NSDictionary)
                self.cateogries.append(cat)
                if index == 0 {
                    self.button1.setTitle(cat.Title, forState: .Normal)
                } else if index == 1 {
                    self.button2.setTitle(cat.Title, forState: .Normal)
                } else if index == 2 {
                    self.button3.setTitle(cat.Title, forState: .Normal)
                } else if index == 3 {
                    self.button4.setTitle(cat.Title, forState: .Normal)
                }
                
                //self.categoryOptions.setTitle(cat.Title, forSegmentAtIndex: index)
            }

            //self.categoryOptions.selectedSegmentIndex = 0
            self.selectType(self.button1)
        }
    }

    
    func resetButtons() {
        self.button1.backgroundColor = UIColor.clearColor()
        self.button1.setTitleColor(theme_color, forState: .Normal)
        
        self.button2.backgroundColor = UIColor.clearColor()
        self.button2.setTitleColor(theme_color, forState: .Normal)
        
        self.button3.backgroundColor = UIColor.clearColor()
        self.button3.setTitleColor(theme_color, forState: .Normal)
        
        self.button4.backgroundColor = UIColor.clearColor()
        self.button4.setTitleColor(theme_color, forState: .Normal)
    }
    
    func showSettings() {
        let vc = Utils.getViewController("AppSettingsViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadLinks() {
        self.links.removeAll()
        let cat = self.cateogries[self.selectedCategory]
        self.links.appendContentsOf(cat.tvs)
        self.collectionView.reloadData()
    }
    
    override func scrollToTop()  {
        self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    func selectType(sender:AnyObject) {
        resetButtons()
        
        let button = sender as! UIButton
        button.backgroundColor = theme_color
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        //self.navigationItem.title = button.titleLabel?.text
        
        switch button {
        case self.button1:
            self.selectedCategory = 0
        case self.button2:
            self.selectedCategory = 1
        case self.button3:
            self.selectedCategory = 2
        case self.button4:
            self.selectedCategory = 3
        default:
            self.selectedCategory = 0
        }
        
        reloadLinks()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.links.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:TVLinkCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! TVLinkCollectionViewCell
        let link = self.links[indexPath.row]
        cell.labelTitle.text = link.Title
        if let imageURL = NSURL(string:link.image) {
            cell.imageViewLink.setImageWithURL(imageURL)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let link = self.links[indexPath.row]
        if link.youtube.characters.count == 0 {
            let vc:JWPlayerViewController = Utils.getViewController("JWPlayerViewController") as! JWPlayerViewController
            vc.file = link.link
            vc.screenTitle = link.Title
            //self.navigationController?.pushViewController(vc, animated: true)
            self.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        } else {
            let vc:XCDYouTubeVideoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: link.youtube)
            self.presentViewController(vc, animated: true, completion: nil)
    //        let url = NSURL(string: link.link)
    //        UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((self.view.frame.width / 2) - 10, 155)
    }
    
}
