//
//  SelectSourcesViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 31/07/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import MapleBacon

class CategoryListViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var categories:[AppCateogry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Localization.get("title_select_sources")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icn_close.png"), style: .Done, target: self, action: #selector(cancel))
        
        self.collectionView.registerNib(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        makeCall(Page.categories, params: [:]) { (response) in
            let array = response as! NSArray
            self.categories.removeAll()
            for item in array {
                self.categories.append(AppCateogry(fromDictionary: item as! NSDictionary))
            }
            self.collectionView.reloadData()
        }
    }

    func cancel() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
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
    
    /*
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let vc:ChannelsViewController = Utils.getViewController("ChannelsViewController") as! ChannelsViewController
        vc.category = self.categories[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CategoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! CategoryTableViewCell
        let category = self.categories[indexPath.row]
        cell.labelTitle.text = category.Title
        if let imageURL = NSURL(string:category.image) {
            cell.imageViewCategory.setImageWithURL(imageURL)
        }
        
        return cell
    }
    */
    
}
