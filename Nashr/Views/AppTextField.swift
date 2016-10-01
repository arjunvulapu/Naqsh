//
//  AppTextField.swift
//  Nashr
//
//  Created by Amit Kulkarni on 18/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

@IBDesignable
class AppTextField: JVFloatLabeledTextField {

    @IBInspectable var inset: CGFloat = 5
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }

}
