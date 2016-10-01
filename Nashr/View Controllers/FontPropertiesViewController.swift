//
//  FontPropertiesViewController.swift
//  Nashr
//
//  Created by Amit Kulkarni on 19/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit

class FontPropertiesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var labelChangeFont: UILabel!
    @IBOutlet weak var labelChangeStyle: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var fontStyle: UISegmentedControl!
    @IBOutlet weak var sliderSize: UISlider!
    @IBOutlet weak var buttonSave: UIButton!
    
    var delegate:PopupCloseDelegate?
    
    let sizes = [Localization.get("font_small"), Localization.get("font_medium"), Localization.get("font_large"), Localization.get("font_xlarge")]
    let values = [16, 18, 20, 22]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.labelTitle.text = Localization.get("title_font_style")
        self.labelChangeFont.text = Localization.get("change_font_size")
        self.labelChangeStyle.text = Localization.get("change_font_style")
        self.buttonSave.setTitle(Localization.get("save"), forState: .Normal)
        
        let size = Settings.titleFont
        if size == 0 {
            Settings.titleFont = 18
        }
    }

    @IBAction func close(sender: AnyObject) {
        self.delegate?.closePopup(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func save(sender: AnyObject) {
//        var fontStyle = ""
//        if self.fontStyle.selectedSegmentIndex == 0 {
//            fontStyle = "normal"
//        } else {
//            fontStyle = "bold"
//        }
//        Settings.currentFont = (Int(self.sliderSize.value), fontStyle)
        self.delegate?.closePopup(self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        cell.textLabel?.text = sizes[indexPath.row]
        let size = Settings.titleFont
        
        if size <= 16 && indexPath.row == 0 {
            cell.accessoryType = .Checkmark
        } else if size > 16 && size <= 18 && indexPath.row == 1 {
            cell.accessoryType = .Checkmark
        } else if size > 18 && size <= 20 && indexPath.row == 2 {
            cell.accessoryType = .Checkmark
        } else if size > 20 && size <= 22 && indexPath.row == 3 {
            cell.accessoryType = .Checkmark
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Settings.currentFont = (values[indexPath.row], Settings.currentFont.style)
        Settings.titleFont = values[indexPath.row]
        self.delegate?.closePopup(self)
    }
}
