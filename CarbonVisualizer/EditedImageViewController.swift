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
        }
        
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    
    

}
