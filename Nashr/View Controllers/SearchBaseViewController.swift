//
//  SearchBaseViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 18/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import Alamofire

class SearchBaseViewController: BaseViewController {
    var searchBar:UISearchBar = UISearchBar(frame: CGRectZero)
    var searchViewCover = UIView(frame:CGRectZero)
    
    var searchbarHidden = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.searchViewCover.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
//        self.searchViewCover.backgroundColor = UIColor.darkGrayColor()
//        self.searchViewCover.alpha = 0.7
//        self.view.addSubview(self.searchViewCover)
        
        self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44)
        self.searchBar.delegate = self
        self.view.addSubview(self.searchBar)
        self.view.bringSubviewToFront(self.searchBar)
    }

//    override func viewWillAppear(animated: Bool) {
//        self.searchbarHidden = true
//        self.searchBar.frame = CGRectMake(0, 44, self.view.frame.size.width, 44)
//        self.searchBar.resignFirstResponder()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchbarHidden = true
        self.searchViewCover.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
        self.searchBar.resignFirstResponder()
    }
    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        Alamofire.Manager.sharedInstance.session.getAllTasksWithCompletionHandler { tasks in
//            tasks.forEach { $0.cancel() }
//        }
//        searchWithText(self.searchBar.text!)
//    }
    
    func searchWithText(text:String) {
        
    }
    
    func cancelSearch() {
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        search()
        searchBar.resignFirstResponder()
        searchWithText(self.searchBar.text!)
//        self.searchbarHidden = true
//        self.searchViewCover.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
//        self.searchBar.frame = CGRectMake(0, -44, self.view.frame.size.width, 44)
//        self.searchBar.resignFirstResponder()
        
//        let vc:SearchViewController = Utils.getViewController("SearchViewController") as! SearchViewController
//        self.searchParams!["search"] = self.searchBar.text
//        vc.searchParams = self.searchParams
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func search() {
        UIView.animateWithDuration(0.5) {
            if self.searchbarHidden {
                self.searchbarHidden = false
                //self.searchViewCover.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                self.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44)
                self.searchBar.becomeFirstResponder()
            } else {
                self.searchbarHidden = true
                //self.searchViewCover.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
                self.searchBar.frame = CGRectMake(0, -44, self.view.frame.size.width, 44)
                self.searchBar.resignFirstResponder()
                self.cancelSearch()
            }
        }
    }
    
}
