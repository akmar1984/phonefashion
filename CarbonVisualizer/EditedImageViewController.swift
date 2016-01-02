//
//  EditedImageViewController.swift
//  CarbonVisualizer
//
//  Created by Marek Tomaszewski on 23/11/2015.
//  Copyright © 2015 RayWenderlich. All rights reserved.
//


import UIKit


class EditedImageViewController: UIViewController, UIScrollViewDelegate {
    
     
    var editedImage: UIImage?
    lazy var imageView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let editedImageScrollView = UIScrollView.init(frame: view.bounds)
        editedImageScrollView.backgroundColor = UIColor.redColor()
        view.addSubview(editedImageScrollView)
        editedImageScrollView.delegate = self
        
        if let editedImage = editedImage {
            imageView.frame = CGRectMake(50, 50, editedImage.size.width, editedImage.size.height)
            imageView.layer.cornerRadius = 20.0
            imageView.clipsToBounds = true
            imageView.image = editedImage
            imageView.backgroundColor = UIColor.redColor()
            editedImageScrollView.addSubview(imageView)
        
        }else{
            let editedImage2 = UIImage(named: "dog.jpg")
        imageView.frame = CGRectMake(0, 50, editedImage2!.size.width, editedImage2!.size.height)
        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
        imageView.image = editedImage2
        imageView.backgroundColor = UIColor.redColor()
            editedImageScrollView.addSubview(imageView)
        }
        
        let cancelButton = UIButton(type: .Custom)
        cancelButton.frame = CGRectMake(0, 10, 70, 60)
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        cancelButton.addTarget(self, action: "cancelButton:", forControlEvents: .TouchUpInside)
        view.addSubview(cancelButton)

    }
    func cancelButton(sender: UIButton){
        dismissViewControllerAnimated(true, completion: nil)
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    
    

}
