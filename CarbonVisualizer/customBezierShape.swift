//
//  customBezierShape.swift
//  PhoneFashionApp
//
//  Created by Marek Tomaszewski on 25/11/2015.
//
//

import UIKit

class customBezierShape: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let borderRect = UIBezierPath(rect: CGRectMake(40.0, 40.0, 400 , 400))
        let color = UIColor.redColor()
        color.setFill()
        color.setStroke()
        borderRect
        borderRect.stroke()
      //  path.appendPath(borderRect)
    }
    

}
