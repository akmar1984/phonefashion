import UIKit
import SceneKit


class CaseModelViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageViewControllerDelegate  {
    
    // UI
    @IBOutlet weak var geometryLabel: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var backCube: SCNNode!
    @IBOutlet weak var homeButtonCube: SCNNode!
    @IBOutlet weak var frontScreen: SCNNode!
    var hasNewImage: Bool = false
    var capturedImage: UIImage!
    //geometry
    var geometryNode: SCNNode = SCNNode()
    
    //gestures
    var currentAngle: Float = 0.0
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        
        if !hasNewImage{
            //extractCubes()
            extractIphone6()
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        sceneView.autoenablesDefaultLighting = true
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 10)
        sceneView.scene!.rootNode.addChildNode(cameraNode)
        sceneView.pointOfView = cameraNode
        sceneView.allowsCameraControl = true
        
    }
    //DELEGATE PROTOCOL METHODS
    func imageViewControllerDidCancel(controller: ImageViewController, didFinishEditingImage editedImage: UIImage) {
        capturedImage = editedImage
        
        let iphoneMaterial = SCNMaterial()
        let material001 = SCNMaterial()
        
        iphoneMaterial.diffuse.contents = UIImage(named: "iphone-6.jpg")
        material001.diffuse.contents = editedImage

       

        geometryNode.geometry?.materials  = [iphoneMaterial, material001]
        
        //REDO THE MAPPING FOR THE BACK CASE MAYBE SELECT THE BACK AND ADD SELECTED MATERIAL ONLY?
        let caseNode = geometryNode.childNodeWithName("case", recursively: true)
        caseNode!.geometry?.materials = [material001]
        
        hasNewImage = true

        dismissViewControllerAnimated(true, completion: nil)
        

    }
    @IBAction func takePicture(sender: UIButton) {
        
        
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
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        //this works for assigning image for an image
        //        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
        //            capturedImage.contentMode = .ScaleAspectFill
        //            capturedImage.image = pickedImage
        //            let iphoneNewMaterial = SCNMaterial()
        //            iphoneNewMaterial.diffuse.contents = pickedImage
        //            backCube.geometry?.materials = [iphoneNewMaterial]
        //
        //            hasNewImage = true
        //
        //
        //
        //        }
        
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
        
            
            
          self.performSegueWithIdentifier("segue", sender: nil)
        }
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segue"{
            let imageViewController = segue.destinationViewController as! ImageViewController
            imageViewController.delegate = self
            imageViewController.newImage = capturedImage
            
            
        }
    }
    func extractIphone6(){
      //  let scene = SCNScene(named: "iPhone 6Exported")
        let scene = SCNScene(named: "iPhone 6WithProperCaseVer3")
        let emptyScene = SCNScene()
        sceneView!.scene = emptyScene
        
        if let phone = scene!.rootNode.childNodeWithName("Cube", recursively: true){
            let iphoneMaterial = SCNMaterial()
            let material001 = SCNMaterial()
            iphoneMaterial.diffuse.contents = UIImage(named: "iphone-6.jpg")
            
            material001.diffuse.contents = UIImage(named: "Diffuse Screen.jpg")
            
           // material001.diffuse.contentsTransform = SCNMatrix4MakeRotation(90, 0, 0, 0)
            //use the order of materials to adjust the different materials
            phone.geometry?.materials = [iphoneMaterial]
            let caseNode = phone.childNodeWithName("case", recursively: true)
            caseNode!.geometry?.materials = [material001]
            geometryNode = phone
            geometryNode.position = SCNVector3Make(0, 0, 0)
            
            geometryNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: 0, z: 0)
            sceneView.scene!.rootNode.addChildNode(geometryNode)
            
        }
        
            
            
//            
//            if let backCubeCase = scene!.rootNode.childNodeWithName("case", recursively: true){
//                let caseMaterial = SCNMaterial()
//                
//                caseMaterial.diffuse.contents = UIImage(named: "04.jpg")
//                backCubeCase.geometry?.materials = [caseMaterial]
//                geometryNode = backCubeCase
//                geometryNode.position = SCNVector3Make(0, 0, 0)
//                
//                //geometryNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: 0, z: 0)
//                sceneView.scene!.rootNode.addChildNode(geometryNode)
//        }
//        
//        
        
    }
    func extractCubes(){
        let scene = SCNScene(named: "Iphone 5cEdited")
        let emptyScene = SCNScene()
        sceneView!.scene = emptyScene
        
        if let phone = scene!.rootNode.childNodeWithName("Cube", recursively: true){
            //            let iphoneMaterial = SCNMaterial()
            
            //            iphoneMaterial.diffuse.contents = UIImage(named: "dog.jpg")
            //            phone.geometry?.materials = [iphoneMaterial]
            geometryNode = phone
            geometryNode.position = SCNVector3Make(0, 0, 0)
            
            geometryNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: 0, z: 0)
            sceneView.scene!.rootNode.addChildNode(geometryNode)
        }
        if let phoneCube = scene!.rootNode.childNodeWithName("Cube_001", recursively: true){
            //            let iphoneMaterial = SCNMaterial()
            //
            //            iphoneMaterial.diffuse.contents = UIImage(named: "iphone-6.jpg")
            //            phoneCube.geometry?.materials = [iphoneMaterial]
            geometryNode = phoneCube
            geometryNode.position = SCNVector3Make(0, 0, 0)
            
            geometryNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: 0, z: 0)
            sceneView.scene!.rootNode.addChildNode(geometryNode)
        }
        if let phoneCube2 = scene!.rootNode.childNodeWithName("Cube_002", recursively: true){
            //            let iphoneMaterial = SCNMaterial()
            //
            //            iphoneMaterial.normal.contents = UIImage(named: "Diffuse Screen.jpg")
            //            phoneCube2.geometry?.materials = [iphoneMaterial]
            phoneCube2.position = SCNVector3Make(0, 0, 0)
            phoneCube2.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: 0, z: 0)
            frontScreen = phoneCube2
            sceneView.scene!.rootNode.addChildNode(frontScreen)
        }
        if let phoneCube3 = scene!.rootNode.childNodeWithName("Cylinder", recursively: true){
            //            let iphoneMaterial = SCNMaterial()
            //
            //            iphoneMaterial.diffuse.contents = UIImage(named: "iphone-6.jpg")
            //            phoneCube3.geometry?.materials = [iphoneMaterial]
            phoneCube3.position = SCNVector3Make(0, 0, 0)
            
            phoneCube3.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: 0, z: 0)
            homeButtonCube = phoneCube3
            sceneView.scene!.rootNode.addChildNode(homeButtonCube)
        }
        if let phoneCube4 = scene!.rootNode.childNodeWithName("Cube_003", recursively: true){
            //   let iphoneMaterial = SCNMaterial()
            
            //            iphoneMaterial.diffuse.contents = UIImage(named: "iphone-6.jpg")
            //            phoneCube3.geometry?.materials = [iphoneMaterial]
            phoneCube4.position = SCNVector3Make(0, 0, 0)
            
            phoneCube4.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: 0, z: 0)
            backCube = phoneCube4
            sceneView.scene!.rootNode.addChildNode(backCube)
        }
        
        
        
    }
    
    
    func panGesture(sender: UIPanGestureRecognizer){
        
        let translation = sender.translationInView(sender.view!)
        var newAngle = (Float)(translation.x)*(Float)(M_PI)/180.0
        newAngle += currentAngle
        
        geometryNode.transform = SCNMatrix4MakeRotation(newAngle, 0, 1, 0)
        
        if(sender.state == UIGestureRecognizerState.Ended) {
            currentAngle = newAngle
        }
    }
    
    
    
    // MARK: Style
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: Transition
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        sceneView!.stop(nil)
        sceneView!.play(nil)
        
    }
}
