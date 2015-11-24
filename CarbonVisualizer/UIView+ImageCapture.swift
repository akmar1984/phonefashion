//
//  UIView+ImageCapture.swift
//  CarbonVisualizer
//
//  Created by Marek Tomaszewski on 23/11/2015.
//  Copyright © 2015 RayWenderlich. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func imageSnapshot() -> UIImage {
        return self.imageSnapshotCroppedToFrame(nil)
    }
    
    func imageSnapshotCroppedToFrame(frame: CGRect?) -> UIImage {
        let scaleFactor = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scaleFactor)
        self.drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let frame = frame {
            // UIImages are measured in points, but CGImages are measured in pixels
            let scaledRect = CGRectApplyAffineTransform(frame, CGAffineTransformMakeScale(scaleFactor, scaleFactor))
            
            if let imageRef = CGImageCreateWithImageInRect(image.CGImage, scaledRect) {
                image = UIImage(CGImage: imageRef)
            }
        }
        return image
    }
}