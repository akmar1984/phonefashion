//
//  UIImage+Scaling.swift
//  CarbonVisualizer
//
//  Created by Marek Tomaszewski on 21/11/2015.
//  Copyright © 2015 RayWenderlich. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    
    class func imageFromView(view: UIView) -> UIImage{
        
        let size = view.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, true, 2.0)
        let hidden: Bool = view.hidden
        view.hidden = false
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        var newImage = UIImage()
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        view.hidden = hidden
        
        return newImage

        
    }
    class func endImageContext(){
     
        UIGraphicsEndImageContext()
    }
    
    class func imageFromView(view: UIView, scaledToSize newSize: CGSize)->UIImage{
        
        var image = UIImage.imageFromView(view)
        if view.bounds.size.width != newSize.width || view.bounds.size.height != newSize.height{
            image = UIImage.imageWithImage(image, scaledToSize: newSize)
            
        }
        
        return image
    }
    /*

+ (UIImage*)imageFromView:(UIView*)view scaledToSize:(CGSize)newSize
{
UIImage *image = [self imageFromView:view];
if ([view bounds].size.width != newSize.width ||
[view bounds].size.height != newSize.height) {
image = [self imageWithImage:image scaledToSize:newSize];
}
return image;
}

*/
    class func imageWithImage(image: UIImage, scaledToSize newSize: CGSize)-> UIImage{
        
        
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        
        var newImage = UIImage()
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        endImageContext()
        return newImage
        
//        [self beginImageContextWithSize:newSize];
//        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//        [self endImageContext];
//        return newImage;
//    http://www.icab.de/blog/2010/10/01/scaling-images-and-creating-thumbnails-from-uiviews/
    
    }
}