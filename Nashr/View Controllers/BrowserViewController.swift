//
//  BrowserViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 18/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit

class BrowserViewController: BaseViewController {

    var url:String?
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string:self.url!)!))
    }

    override func viewWillAppear(animated: Bool) {
        self.webView.backgroundColor = UIColor.clearColor()
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
