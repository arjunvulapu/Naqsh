//
//  Comment.swift
//  Nashr
//
//  Created by Amit Kulkarni on 01/08/16.
//  Copyright © 2016 Amit Kulkarni. All rights reserved.
//

import UIKit

@IBDesignable class CommentView: UIView {
    
    var color:UIColor = UIColor.blackColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required convenience init(withColor frame: CGRect, color:UIColor? = .None) {
        self.init(frame: frame)
        
        if let color = color {
            self.color = color
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.layer.cornerRadius = 10
        
        self.clipsToBounds = true
        
//        let rounding:CGFloat = rect.width * 0.02
//        
//        //Draw the main frame
//        
//        let bubbleFrame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height - 50)
//        let bubblePath = UIBezierPath(roundedRect: bubbleFrame, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: rounding, height: rounding))
//        
//        //Color the bubbleFrame
//        
//        color.setStroke()
//        //color.setFill()
//        bubblePath.stroke()
//        //bubblePath.fill()
//        
//        //Add the point
//        
//        let context = UIGraphicsGetCurrentContext()
//        
//        //Start the line
//        
//        CGContextBeginPath(context)
//        CGContextMoveToPoint(context, CGRectGetMinX(bubbleFrame) + bubbleFrame.width * 1/3, CGRectGetMaxY(bubbleFrame))
//        
//        //Draw a rounded point
//        
//        CGContextAddArcToPoint(context, CGRectGetMaxX(rect) * 1/3, CGRectGetMaxY(rect), CGRectGetMaxX(bubbleFrame), CGRectGetMinY(bubbleFrame), rounding)
//        
//        //Close the line
//        
//        CGContextAddLineToPoint(context, CGRectGetMinX(bubbleFrame) + bubbleFrame.width * 2/3, CGRectGetMaxY(bubbleFrame))
//        CGContextClosePath(context)
//        
//        //fill the color
//        
//        //CGContextSetFillColorWithColor(context, color.CGColor)
//        //CGContextFillPath(context);
        
    }

}
