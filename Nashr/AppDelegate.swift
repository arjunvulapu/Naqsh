//
//  AppDelegate.swift
//  Nashr
//
//  Created by Amit Kulkarni on 19/07/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManager
import SVProgressHUD
import Alamofire
import MediaPlayer
import FBSDKCoreKit

class MyTabBar : UITabBar {
    override func sizeThatFits(size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 60
        return sizeThatFits
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?
    var dictionary:NSDictionary?
    var lastViewController:UIViewController?

    func reloadUI() {
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabbarcontroller")
//        UIView.appearance().semanticContentAttribute = .ForceRightToLeft
        //UIView.appearanceWhenContainedInInstancesOfClasses([UITableViewCell.self]).semanticContentAttribute = .Unspecified
        
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UIButton.appearance().semanticContentAttribute = .ForceRightToLeft
        UILabel.appearance().semanticContentAttribute = .ForceRightToLeft
//        UITableView.appearance().semanticContentAttribute = .ForceRightToLeft
//        UITableViewCell.appearance().semanticContentAttribute = .ForceRightToLeft
        reloadTabs()
    }
    
    func downloadTranslation() {
        print ("path: \(Localization.path)")
        let data:NSData? = NSURLSession.requestSynchronousData(NSURLRequest(URL: NSURL(string: Api.getUrl(Page.words))!))
        try! data!.writeToFile(Localization.path, options: NSDataWritingOptions.AtomicWrite)
        Settings.wordsDownloaded = true
    }
    
    func downloadSettings() {
        let data:NSData? = NSURLSession.requestSynchronousData(NSURLRequest(URL: NSURL(string: Api.getUrl(Page.settings))!))
        self.dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
        
        /*
        SVProgressHUD.showAnimatedImages()
        Alamofire
            .request(.POST, Api.getUrl(Page.settings), parameters: [:])
            .responseJSON(completionHandler: { (response) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .Success(let JSON):
                    self.dictionary = JSON as? NSDictionary
                    
                case .Failure(let error):
                    print("error: \(error)")
                }
            })*/
    }
    
    func reloadTabs() {
        let tabbar:UITabBarController = self.window?.rootViewController as! UITabBarController
        tabbar.delegate = self
        tabbar.selectedIndex = 0

        tabbar.tabBar.items![4].title = Localization.get("tab_settings")
        tabbar.tabBar.items![3].title = Localization.get("tab_tv_live")
        tabbar.tabBar.items![2].title = Localization.get("tab_sports")
        tabbar.tabBar.items![1].title = Localization.get("tab_economy")
        tabbar.tabBar.items![0].title = Localization.get("tab_news")
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSFontAttributeName: UIFont(name:"HelveticaNeueLTArabic-Bold", size:13)!,
                NSForegroundColorAttributeName: UIColor.grayColor()],
            forState: .Normal)
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if viewController == self.lastViewController {
            let vc:BaseViewController = (viewController as! UINavigationController).topViewController as! BaseViewController
            vc.scrollToTop()
        }
        
        lastViewController = viewController
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        if let presentedViewController = self.window!.rootViewController?.presentedViewController {
            if (presentedViewController.isKindOfClass(MPMoviePlayerViewController.self) && !presentedViewController.isBeingDismissed()) {
                return .AllButUpsideDown
            }
        }
        return .Portrait
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //UIView.appearance().semanticContentAttribute = .ForceRightToLeft
        IQKeyboardManager.sharedManager().enable = true
        if Utils.isInternetAvailable() {
            downloadTranslation()
            downloadSettings()
            reloadTabs()
        } else {
            self.window?.rootViewController = Utils.getViewController("InternetStatusViewController")
        }
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let result = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        return result
    }
    
    func applicationWillResignActive(application: UIApplication) {
        print("applicationWillResignActive")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        print("applicationDidEnterBackground")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        print("applicationWillEnterForeground")
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        print("applicationDidBecomeActive")
        FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "iMagic-Software.Nashr" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Nashr", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

