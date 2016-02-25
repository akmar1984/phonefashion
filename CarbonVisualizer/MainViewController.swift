//
//  MainViewController.swift
//  PhoneFashionApp
//
//  Created by Marek Tomaszewski on 30/11/2015.
//
//

import UIKit
import SceneKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageViewControllerDelegate  {

    var capturedImage: UIImage!
    var hasNewImage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

                // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHome(unwindSegue: UIStoryboardSegue){
        
//        
//                if let sourceViewController = unwindSegue.sourceViewController as? ShippingSummaryViewController {
//                    performSegueWithIdentifier("unwindSegue", sender: self)
//                    print("hit the unwindToHome2")
//                }
//       
        
        
    }
    
    @IBAction func getOneNowButton(sender: UIButton) {
        let actionSheet = UIAlertController(title: "Pick one of the options:", message: "", preferredStyle: .ActionSheet)
        let actionCamera = UIAlertAction(title: "Camera", style: .Default) { (action) -> Void in
            //CAMERA
            if UIImagePickerController .isSourceTypeAvailable(.Camera){
                
                let cameraPicker = UIImagePickerController()
                cameraPicker.delegate = self
                cameraPicker.allowsEditing = false
                cameraPicker.sourceType = .Camera
                
            

                self.presentViewController(cameraPicker, animated: true, completion: nil)
            }
            else {
                print("NO CAMERA PRESENTED")
                let noCamera = UIAlertController(title: "Error", message: "Sorry No Camera Present", preferredStyle: .Alert)
                let dismissAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                noCamera.addAction(dismissAction)
                self.presentViewController(noCamera, animated: true, completion: nil)
            }
            //comment in if you want to use the photos built in or camera
            
        }
        actionSheet.addAction(actionCamera)
        let actionLibrary = UIAlertAction(title:"Library", style: .Default) { (
            action) -> Void in
            //PHOTO GALLERY
            let libraryPicker = UIImagePickerController()
            libraryPicker.delegate = self
            libraryPicker.allowsEditing = false
            libraryPicker.sourceType = .PhotoLibrary
            
            self.presentViewController(libraryPicker, animated: true, completion: nil)
            
            
        }
        actionSheet.addAction(actionLibrary)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
        
        

    }
   
    //MARK: ImagePickerDelegate methods
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        if let  pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            //            let iphoneMaterial = SCNMaterial()
            //            let material001 = SCNMaterial()
            //            iphoneMaterial.diffuse.contents = UIImage(named: "iphone-6.jpg")
            //            material001.diffuse.contents = pickedImage
            
            capturedImage = pickedImage
            //            geometryNode.geometry?.materials  = [iphoneMaterial, material001]
            hasNewImage = true
            
            
            
        }
        
        dismissViewControllerAnimated(true) { () -> Void in
            
            
            
            self.performSegueWithIdentifier("segueOne", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueOne"{
            let imageViewController = segue.destinationViewController as! ImageViewController
           
            imageViewController.delegate = self
            imageViewController.newImage = capturedImage
            
            
        }
      
    }
    //MARK: Delegate Method
    func imageViewControllerDidCancel(controller: ImageViewController, didFinishEditingImage editedImage: UIImage) {
        capturedImage = editedImage
        
//        let iphoneMaterial = SCNMaterial()
//        let material001 = SCNMaterial()
//        
//        iphoneMaterial.diffuse.contents = UIImage(named: "iphone-6.jpg")
//        material001.diffuse.contents = editedImage
//        
//        
//        
//        geometryNode.geometry?.materials  = [iphoneMaterial, material001]
//        
//        //REDO THE MAPPING FOR THE BACK CASE MAYBE SELECT THE BACK AND ADD SELECTED MATERIAL ONLY?
//        let caseNode = geometryNode.childNodeWithName("case", recursively: true)
//        caseNode!.geometry?.materials = [material001]
//        
//        hasNewImage = true
//        
//        dismissViewControllerAnimated(true, completion: nil)
        
        
    }

}
