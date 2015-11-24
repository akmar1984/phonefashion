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
    var newImage: UIImage!
    var imageView: UIImageView!
    var overlay: UIView!
    var someView: UIView!
    var scrollViewNew: UIScrollView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        
        scrollViewNew.addSubview(imageView)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let image = UIImage(named:"04.jpg")!
        imageView = UIImageView(image: newImage)
        imageView.frame = CGRect(origin: CGPointZero, size: image.size)
        //scrollViewNew = UIScrollView(frame: CGRectMake(-100, -100, view.bounds.width + 100, view.bounds.height + 100))
        scrollViewNew = UIScrollView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height))
        scrollViewNew.backgroundColor = UIColor.redColor()
        scrollViewNew.delegate = self
        //        scrollViewNew.contentInset = UIEdgeInsetsMake(<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)
        scrollViewNew.contentInset = UIEdgeInsetsMake(100, 200, 200, 200)
       
        
        
        scrollViewNew.contentSize = CGSizeMake(image.size.width + 1000, image.size.height + 1000)
        // scrollViewNew.contentSize = imageView.bounds.size
      //  scrollViewNew.contentMode = .ScaleAspectFill
        //  scrollViewNew.contentSize = CGSizeMake(1000, 1000)
        
        scrollViewNew.minimumZoomScale = 0.5
        scrollViewNew.maximumZoomScale = 1.2
        //scrollViewNew.clipsToBounds = true
        scrollViewNew.bounces = false
        view.addSubview(scrollViewNew)
        
        
//        let image = UIImage(named:"iphone-6.jpg")!
//        scrollView.delegate = self
//        //scrollView.contentInset = UIEdgeInsetsMake(100, 100, 70, 50)
//        scrollView.contentSize = image.size
//        scrollView.backgroundColor = UIColor.blackColor()
//       
//        imageView = UIImageView(image: image)
//        imageView.frame = CGRect(origin: CGPointZero, size: image.size)
//        scrollView.addSubview(imageView)
//      //  scrollView.contentSize = image.size
//        
//        let doubleTap = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
//        doubleTap.numberOfTapsRequired = 2
//        doubleTap.numberOfTouchesRequired = 1
//        scrollView.addGestureRecognizer(doubleTap)
//        
//        
//        let scrollViewFrame = scrollView.frame
//        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
//        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
//        let minScale = min(scaleWidth, scaleHeight)
//       
//        
//        //correct the scrolling feature!!!!
//        // scrollView.minimumZoomScale = minScale
//        scrollView.minimumZoomScale = 0.5
//        scrollView.maximumZoomScale = 1.2
//        scrollView.setContentOffset(CGPointMake(0, 100), animated: true)
//        //scrollView.zoomScale = minScale
////  
//        self.automaticallyAdjustsScrollViewInsets = false
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
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        scrollView.contentSize = CGSizeMake(imageView.image!.size.width + 2000, imageView.image!.size.height + 1000)
        scrollViewNew.contentInset = UIEdgeInsetsMake(100, 200, 200, 200)
        
        
        
    }
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
        
    }
    
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
    
//    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
//        
//        scrollViewNew.contentSize = CGSizeMake(self.view.bounds.width * scale, self.view.bounds.height * scale)
//        
//        
//
//    }
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
