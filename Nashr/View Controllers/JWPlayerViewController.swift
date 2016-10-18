//
//  JWPlayerViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 17/10/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit

class JWPlayerViewController: BaseViewController {

    var player:JWPlayerController!
    var file:String = ""
    var screenTitle:String = ""
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.screenTitle
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(back))
        
        let config: JWConfig = JWConfig()
        config.sources = [JWSource (file: file, label: "")]
        config.controls = true  //default
        config.`repeat` = false   //default
        
        let captionStyling: JWCaptionStyling = JWCaptionStyling()
        captionStyling.font = UIFont (name: "Zapfino", size: 20)
        captionStyling.edgeStyle = raised
        captionStyling.windowColor = theme_color
        captionStyling.backgroundColor = UIColor(red: 0.3, green: 0.6, blue: 0.3, alpha: 0.7)
        captionStyling.fontColor = UIColor.whiteColor()
        config.captionStyling = captionStyling
        
        let adConfig: JWAdConfig = JWAdConfig()
        adConfig.adClient = vastPlugin
        config.adConfig = adConfig
        config.autostart = true
        
        self.player = JWPlayerController(config: config)
        //self.player.delegate = self
        
        var frame: CGRect = self.view.bounds
//        frame.origin.y = 10
//        frame.size.height /= 2
//        frame.size.height -= 44
        
        self.player.view.frame = frame
        //        self.player.view.autoresizingMask = [
        //            UIViewAutoresizing.flexibleBottomMargin,
        //            UIViewAutoresizing.flexibleHeight,
        //            UIViewAutoresizing.flexibleLeftMargin,
        //            UIViewAutoresizing.flexibleRightMargin,
        //            UIViewAutoresizing.flexibleTopMargin,
        //            UIViewAutoresizing.flexibleWidth]
        
        self.player.openSafariOnAdClick = true
        self.player.forceFullScreenOnLandscape = true
        self.player.forceLandscapeOnFullScreen = true
        
        self.view.addSubview(player.view)
        self.player.play()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.player.stop()
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
