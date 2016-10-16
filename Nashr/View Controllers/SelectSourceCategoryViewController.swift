//
//  SelectSourceCategoryViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 07/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import RealmSwift

class SelectSourceCategoryViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    var selectedChannel:((channel:Chanel) -> Void)?
    var cancel:(() -> Void)?
    var delegate:PopupCloseDelegate?
    var onlyGenerally = false
    var channels:[Chanel] = []
    var parentCategory:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonCancel.setTitle(Localization.get("cancel"), forState: .Normal)
        self.labelTitle.text = Localization.get("title_select_sources")
        
        self.view.backgroundColor = UIColor.clearColor()
        
        self.container.layer.cornerRadius = 10
        self.container.clipsToBounds = true
        
        self.tableView.registerNib(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.rowHeight = 50
        
        var channelIds:[String] = []
        let items = try! Realm().objects(SavedCategory)
        for cat in items {
            if self.onlyGenerally == true {
                if (cat.categoryId == 29) || (cat.categoryId == 4) {
                    continue
                }
            }
            
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
            }
        } else {
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.channels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CategoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! CategoryTableViewCell
        
        let cat:Chanel = self.channels[indexPath.row]
        
        cell.labelTitle.text = cat.Title
        if let imageURL = NSURL(string:cat.image) {
            cell.imageViewCategory.setImageWithURL(imageURL)
        }
        
        return cell
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.cancel?()
        self.delegate?.closePopup(self)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedChannel?(channel:self.channels[indexPath.row])
        self.delegate?.closePopup(self)
    }
    
}
