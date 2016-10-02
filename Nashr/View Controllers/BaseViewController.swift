//
//  BaseViewController.swift
//  OnItsWay
//
//  Created by Amit Kulkarni on 12/07/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

extension UILabel {
    
    var substituteFontName : String {
        get { return self.font.fontName }
        set {
            self.font = UIFont(name: newValue, size: self.font.pointSize)
        }
    }
    
}

class BaseViewController: UIViewController, UISearchBarDelegate, PopupCloseDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for familyName:AnyObject in UIFont.familyNames() {
//            print("Family Name: \(familyName)")
//            for fontName:AnyObject in UIFont.fontNamesForFamilyName(familyName as! String) {
//                print("--Font Name: \(fontName)")
//            }
//        }
        
        //UILabel.appearance().substituteFontName = "NotoNaskhArabic";
        UILabel.appearanceWhenContainedInInstancesOfClasses([UIButton.self]).substituteFontName = "NotoNaskhArabic-Bold"
        
        self.navigationController?.navigationBar.opaque = true
        self.navigationController?.navigationBar.translucent = false

        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName:UIFont(name: "HelveticaNeueLTArabic-Bold", size: 16)!]
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.090,  green:0.568,  blue:0.813, alpha:1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        //self.navigationController?.navigationBar.semanticContentAttribute = .ForceLeftToRight
    }
    
    func scrollToTop() {
    }
    
    func closePopup(vc: UIViewController) {
        self.dismissPopupViewControllerWithanimationType(MJPopupViewAnimationSlideBottomTop)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showErrorAlert(message:String) {
        SweetAlert().showAlert(Localization.get("warning"), subTitle: Localization.get(message), style: AlertStyle.Error)
    }
    
    func showSuccessAlert(message:String) {
        SweetAlert().showAlert("", subTitle: Localization.get(message), style: AlertStyle.Success)
    }
    
    func makeCall(api:Page, params:[String:AnyObject], showIndicator:Bool = true, completionHandler:(response:AnyObject)->Void) {
        if !Utils.isInternetAvailable() {
            let vc:InternetStatusViewController = InternetStatusViewController(nibName: "InternetStatusViewController", bundle: nil)
            vc.delegate = self
            self.presentPopupViewController(vc, animationType: MJPopupViewAnimationSlideBottomTop)
            return
        }
        
        if showIndicator {
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Clear)
            SVProgressHUD.showImage(UIImage(named: "logo.png"), status: "")
        }
        
        
        var dictionary:[String:AnyObject] = params
        dictionary["lang"] = Localization.currentLanguage().rawValue
        
        Alamofire
            .request(.POST, Api.getUrl(api), parameters: dictionary)
            .responseJSON(completionHandler: { (response) in
                print ("result arrived in base class")
                switch response.result {
                case .Success(let JSON):
                    completionHandler(response: JSON)
                    
                case .Failure(let error):
                    //self.showErrorAlert("api_error")
                    print("error: \(error)")
                }
                
                if showIndicator {
                    SVProgressHUD.dismiss()
                }

            })
    }
}
