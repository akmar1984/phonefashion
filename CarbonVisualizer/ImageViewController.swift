//
//  ImageViewController.swift
//  CarbonVisualizer
//
//  Created by Marek Tomaszewski on 12/11/2015.
//  Copyright © 2015 RayWenderlich. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
   // var newImage: UIImage!
    var imageView: UIImageView!
    var overlay: UIView!
    var someView: UIView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named:"iphone-6.jpg")!
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: CGPointZero, size: image.size)
        
        scrollView.delegate = self
        scrollView.addSubview(imageView)
      //  scrollView.contentSize = image.size
        
        let doubleTap = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTap)
        
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        scrollView.minimumZoomScale = minScale
        
        // 5
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale
        
        //centerScrollViewContents()
        addOverlay()
        
       
        
    }
    func addOverlay(){
        let offset: CGFloat = 40.0
        let overlayFrame = CGRectMake(offset, offset, view.bounds.size.width - offset * 2, view.bounds.size.height - offset * 2)
        overlay = UIView(frame: overlayFrame)
        overlay.backgroundColor = UIColor.redColor()
        overlay.alpha = 0.1
        overlay.userInteractionEnabled = false
        view.addSubview(overlay)
        
    }
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer){
        
//        let pointInView = recognizer.locationInView(imageView)
//        
//        var newZoomScale = scrollView.zoomScale * 1.5
//        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
//        let scrollViewSize = scrollView.bounds.size
//        let w = scrollViewSize.width / newZoomScale
//        let h = scrollViewSize.height / newZoomScale
//        let x = pointInView.x - (w / 2.0)
//        let y = pointInView.y - (h / 2.0)
//        
//        let rectToZoomTo = CGRectMake(x, y, w, h);
//        
//        // 4
//        scrollView.zoomToRect(rectToZoomTo, animated: true)

        let contextImage: UIImage =  captureImage()
        imageView.image = contextImage
        scrollView.contentSize = contextImage.size
         self.performSegueWithIdentifier("editedImage", sender: nil)
        
    }
    
    
    func captureImage()-> UIImage {
        overlay.hidden = true
        UIGraphicsBeginImageContextWithOptions(overlay.bounds.size, true, 0.0) //or UIScreen.mainScreen().scalefor scale ?
        view.drawViewHierarchyInRect(CGRectMake(-50, -50, view.bounds.size.width, view.bounds.size.height), afterScreenUpdates: true)
        var newImage = UIImage()
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        overlay.hidden = false
        
        return newImage
        
        
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editedImage"{
            let editedImageViewController = segue.destinationViewController as! EditedImageViewController
                 editedImageViewController.editedImage = imageView.image!
               // editedImageViewController.view.addSubview(someView)
            
            
            
        }
        
    }
//    func scrollViewDidZoom(scrollView: UIScrollView) {
//        centerScrollViewContents()
//    }
    
    func centerScrollViewContents(){
        //centers the image in the center
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width{
            //if width of the imageView is less than scrollView Width set the origin to middle
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        }else{
            contentsFrame.origin.x = 0.0
            
        }
        if contentsFrame.size.height < boundsSize.height {
            
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        imageView.frame = contentsFrame

    }
        func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
