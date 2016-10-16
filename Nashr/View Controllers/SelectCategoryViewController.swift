//
//  SelectCategoryViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 03/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit

class SelectCategoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var lagelTitle: UILabel!
    var selectedCategory:((category:AppCateogry) -> Void)?
    var cancel:(() -> Void)?
    var delegate:PopupCloseDelegate?
    
    @IBOutlet weak var buttonCancenl: UIButton!
    var categories:[AppCateogry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        
        self.container.layer.cornerRadius = 10
        self.container.clipsToBounds = true
        
        self.lagelTitle.text = Localization.get("select_country")
        self.buttonCancenl.setTitle(Localization.get("cancel"), forState: .Normal)
        
        self.tableView.registerNib(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.rowHeight = 50
        
        makeCall(Page.categories, params: ["type":"country"]) { (response) in
            let array = response as! NSArray
            self.categories.removeAll()
            for item in array {
                self.categories.append(AppCateogry(fromDictionary: item as! NSDictionary))
            }
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CategoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! CategoryTableViewCell
        
        let cat:AppCateogry = self.categories[indexPath.row]
        
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
        self.selectedCategory?(category:self.categories[indexPath.row])
        self.delegate?.closePopup(self)
    }
    
}
