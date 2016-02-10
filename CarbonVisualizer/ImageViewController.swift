//
//  ImageViewController.swift
//  CarbonVisualizer
//
//  Created by Marek Tomaszewski on 12/11/2015.
//  Copyright © 2015 RayWenderlich. All rights reserved.
//

import UIKit
protocol ImageViewControllerDelegate {
    
    //func imageViewControllerDidCancel(controller: ImageViewController, didFinishEditingImage editedImage: ViewController)
    func imageViewControllerDidCancel(controller: ImageViewController, didFinishEditingImage editedImage: UIImage)

    
}
class ImageViewController: UIViewController, UIScrollViewDelegate {

    
    
    var delegate: ImageViewControllerDelegate?
    var newImage: UIImage?
    var imageViewWithIphoneEdges: UIImageView!
    var imageView: UIImageView!
    var overlay: UIView!
    var someView: UIView!
    var scrollViewNew: UIScrollView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
   
    
    func done(sender: UIGestureRecognizer){
        
//        let contextImage: UIImage =  captureImage()
//        imageView.image = contextImage
//        delegate?.imageViewControllerDidCancel(self, didFinishEditingImage: imageView.image!)
        

        self.performSegueWithIdentifier("segueCase", sender: nil)
        
    }
    func previewButton(sender: UIButton){
        self.performSegueWithIdentifier("editedImageTwo", sender: nil)
   
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView()
        let image = UIImage(named:"04.jpg")!
        if let tempImage = newImage {
            print("NewImageWorks")
            imageView.image = tempImage
            imageView.frame = CGRect(origin: CGPointZero, size: tempImage.size)
        }else{
            
            imageView = UIImageView(image:image)
            imageView.frame = CGRect(origin: CGPointZero, size: image.size)
        }
        
       
       
        scrollViewNew = UIScrollView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height))
        scrollViewNew.backgroundColor = UIColor.blueColor()
        scrollViewNew.delegate = self
        scrollViewNew.contentInset = UIEdgeInsetsMake(100, 200, 200, 200)// (<#T##top: CGFloat##CGFloat#>, <#T##left: CGFloat##CGFloat#>, <#T##bottom: CGFloat##CGFloat#>, <#T##right: CGFloat##CGFloat#>)

       
        
        
        scrollViewNew.contentSize = CGSizeMake(imageView.image!.size.width + 1000, imageView.image!.size.height + 1000)
        scrollViewNew.minimumZoomScale = 0.2
        scrollViewNew.maximumZoomScale = 6.0
      
        ///scrollViewNew.clipsToBounds = true
       // scrollViewNew.bounces = false
        view.addSubview(scrollViewNew)
        scrollViewNew.addSubview(imageView)

        let previewButton = UIButton(type: .Custom)
        previewButton.frame = CGRectMake(0, 10, 70, 60)
        previewButton.setTitle("Preview", forState: UIControlState.Normal)
        previewButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        previewButton.addTarget(self, action: "previewButton:", forControlEvents: .TouchUpInside)
        view.addSubview(previewButton)

        
        
        let doubleTap = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
       // scrollViewNew.addGestureRecognizer(doubleTap)
        
        let tripleTap = UITapGestureRecognizer(target: self, action: "done:")
        tripleTap.numberOfTapsRequired = 3
        tripleTap.numberOfTouchesRequired = 1
        scrollViewNew.addGestureRecognizer(tripleTap)
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
        
        transparentOverlay()
       
      
        
       
        
    }
    
    func transparentOverlay(){
       // let offset: CGFloat = 40.0
        
         //overlay image width should be width:  80mm x 134mm=  226points x 379points, (154mm x 88mm = 436.32p x 249.12p)

        let overlayFrame = CGRectMake(0, 0, 249.12, 436.32)
      //  let overlayFrame = CGRectMake(offset, offset, view.bounds.size.width - offset * 2, view.bounds.size.height - offset * 2)
        overlay = UIView(frame: overlayFrame)
//        overlay.alpha = 0.1
//        overlay.userInteractionEnabled = false
        
    
        
        print("view width:\(view.frame.size.width), h:\(view.frame.size.height)")

        print("overlay width:\(overlay.frame.size.width), h:\(overlay.frame.size.height)")
        let path = UIBezierPath(roundedRect: CGRectMake(0, 0, view.bounds.width, view.bounds.height), cornerRadius: 0)
       // let roundRect = UIBezierPath(roundedRect: CGRectMake(70, 70, overlay.bounds.width, overlay.bounds.height), cornerRadius: 20.0)

        let normalRect = UIBezierPath(rect: CGRectMake(50, 50, overlay.bounds.width, overlay.bounds.height))
        path.usesEvenOddFillRule = false

        path.appendPath(normalRect) //path.appendPath(roundRect)
        
       
    
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.CGPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = UIColor.blackColor().CGColor
        fillLayer.opacity = 0.5
        view.layer.addSublayer(fillLayer)
        
        
        drawIphoneEdges()
        
    }
    func drawIphoneEdges() {
        
        let image = UIImage(named: "iphone6templateEdited.png")
        
        
        
        imageViewWithIphoneEdges = UIImageView(frame: CGRectMake(0, 0, 0, 0))
        imageViewWithIphoneEdges.image = image
        imageViewWithIphoneEdges.frame = CGRectMake(50, 50, overlay.frame.width, overlay.frame.height)
//        imageViewWithIphoneEdges.contentMode = .ScaleToFill
        
        view.addSubview(imageViewWithIphoneEdges)

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
        //scrollViewNew.contentSize = contextImage.size
         self.performSegueWithIdentifier("editedImageTwo", sender: nil)
        
    }
    
    
    func captureImage()-> UIImage {
        //overlay.hidden = true
        imageViewWithIphoneEdges.hidden = true
        UIGraphicsBeginImageContextWithOptions(overlay.bounds.size, true, 0.0) //or UIScreen.mainScreen().scalefor scale ?
        view.drawViewHierarchyInRect(CGRectMake(-50, -50, view.bounds.size.width, view.bounds.size.height), afterScreenUpdates: true)
        var newImage = UIImage()
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        //overlay.hidden = false
        imageViewWithIphoneEdges.hidden = false
        return newImage
        
        
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editedImage"{
            let editedImageViewController = segue.destinationViewController as! EditedImageViewController
                 editedImageViewController.editedImage = imageView.image!
               // editedImageViewController.view.addSubview(someView)
            

        }
        if segue.identifier == "editedImageTwo"{
            let editedImageViewController = segue.destinationViewController as! EditedImageViewController
            editedImageViewController.editedImage = captureImage()

            
            
        }
        
        if segue.identifier == "segueCase"{
//            let navigationController = segue.destinationViewController as! UINavigationController
//            let controller = navigationController.topViewController as ItemDetailViewController
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! CaseModelViewController
            controller.capturedImage = captureImage()
        
        }
    }
//    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
//        scrollViewNew.contentSize = CGSizeMake(imageView.image!.size.width + 2000, imageView.image!.size.height + 1000)
//        scrollViewNew.contentInset = UIEdgeInsetsMake(100, 200, 200, 200)
//        
//        
//        
//    }
//    func scrollViewDidZoom(scrollView: UIScrollView) {
//        centerScrollViewContents()
//        
//    }
    
    func centerScrollViewContents(){
        //centers the image in the center
        let boundsSize = scrollViewNew.bounds.size
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
    
    
    
    
}
