//
//  Utils.swift
//  OnItsWay
//
//  Created by Amit Kulkarni on 14/07/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import SystemConfiguration

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .Reachable
        let needsConnection = flags == .ConnectionRequired
        
        return isReachable && !needsConnection
        
    }
}

struct Utils {
    
    static func isInternetAvailable() -> Bool {
        var connection = false
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            connection = false
        case .Online(.WWAN):
            connection = true
        case .Online(.WiFi):
            connection = true
        }
        
        return connection
        
        //return Reachability.isConnectedToNetwork()
    }
    
    static func getViewController(id:String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(id)
    }
    
    
    static func getTemplateImage(imageName:String) -> UIImage {
        return (UIImage(named: imageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))!
    }
}