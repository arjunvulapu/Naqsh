//
//  SelectLanguageViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 19/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit

class SelectLanguageViewController: BaseViewController {

    var delegate:PopupCloseDelegate?
    @IBOutlet weak var labelTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelTitle.text = Localization.get("change_language")
    }

    @IBAction func cancel(sender: AnyObject) {
        self.delegate?.closePopup(self)
    }
    
    @IBAction func selectArabic(sender: AnyObject) {
        Localization.changeLanguage(Localization.Language.Arabic)
    }
    
    @IBAction func selectFrench(sender: AnyObject) {
        Localization.changeLanguage(Localization.Language.French)
    }
    
    @IBAction func selectEnglish(sender: AnyObject) {
        Localization.changeLanguage(Localization.Language.English)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
