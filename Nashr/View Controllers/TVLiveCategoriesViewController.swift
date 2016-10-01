//
//  TVLiveCategoriesViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 29/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class TVLiveCategoriesViewController: PagerController, PagerDataSource {

    var cateogries:[TvLiveCategory] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        self.navigationController?.navigationBar.opaque = true
        self.navigationController?.navigationBar.translucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName:UIFont(name: "Lato", size: 16)!]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.090,  green:0.568,  blue:0.813, alpha:1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationController?.navigationBar.semanticContentAttribute = .ForceLeftToRight
        
        self.navigationItem.title = Localization.get("title_tv_live")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings_edit_sources.png"), style: .Done, target: self, action: #selector(showSettings))
        
        
        indicatorColor = theme_color
        tabsViewBackgroundColor = UIColor.whiteColor()
        contentViewBackgroundColor = UIColor.whiteColor()
        
        startFromSecondTab = false
        centerCurrentTab = true
        tabLocation = PagerTabLocation.Top
        tabHeight = 40
        tabOffset = 36
        tabWidth = 96.0
        fixFormerTabsPositions = false
        fixLaterTabsPosition = false
        animation = PagerAnimation.During
        tabsTextColor = theme_color
        selectedTabTextColor = theme_color
        
        self.setupPager(tabNames: [], tabControllers: [])
        
        makeCall(Page.tvLiveCategories, params: [:]) { (response) in
            let array = response as! NSArray
            self.cateogries.removeAll()
            var titles:[String] = []
            var vcs:[TVLiveViewController] = []
            for item in array {
                let cat:TvLiveCategory = TvLiveCategory(fromDictionary: item as! NSDictionary)
                self.cateogries.append(cat)
                titles.append(cat.Title)
                
                let vc:TVLiveViewController = Utils.getViewController("TVLiveViewController") as! TVLiveViewController
                vc.categoryId = cat.id
                vcs.append(vc)
            }
            
            titles.append(Localization.get("all"))
            
            let vc:TVLiveViewController = Utils.getViewController("TVLiveViewController") as! TVLiveViewController
            vc.categoryId = ""
            vcs.append(vc)
            
            self.setupPager(tabNames: titles, tabControllers: vcs)
            self.reloadData()
        }
    }
    
    func showErrorAlert(message:String) {
        SweetAlert().showAlert(Localization.get("warning"), subTitle: Localization.get(message), style: AlertStyle.Error)
    }
    
    func showSuccessAlert(message:String) {
        SweetAlert().showAlert("", subTitle: Localization.get(message), style: AlertStyle.Success)
    }

    func makeCall(api:Page, params:[String:AnyObject], completionHandler:(response:AnyObject)->Void) {
        
        SVProgressHUD.showImage(UIImage(named: "logo.png"), status: Localization.get("please_wait"))
        Alamofire
            .request(.POST, Api.getUrl(api), parameters: params)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .Success(let JSON):
                    completionHandler(response: JSON)
                    
                case .Failure(let error):
                    self.showErrorAlert("api_error")
                    print("error: \(error)")
                }
                
                SVProgressHUD.dismiss()
                
            })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showSettings() {
        let vc = Utils.getViewController("AppSettingsViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
}
