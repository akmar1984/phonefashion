import UIKit
import SceneKit


class CaseModelViewController: UIViewController, PayPalPaymentDelegate  {
    
    // UI
    @IBOutlet weak var geometryLabel: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var backCube: SCNNode!
    @IBOutlet weak var homeButtonCube: SCNNode!
    @IBOutlet weak var frontScreen: SCNNode!

    var hasNewImage: Bool = false
    var capturedImage: UIImage!
    var geometryNode: SCNNode = SCNNode()
    var currentAngle: Float = 0.0
    
    //PAYPAL!
    var payPalConfiguration: PayPalConfiguration!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentNoNetwork)
        if !hasNewImage{
            //extractCubes()
            extractIphone6()
            
        }
    }
    

    @IBAction func cancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        payPalConfiguration = PayPalConfiguration()
        payPalConfiguration.acceptCreditCards = true
        payPalConfiguration.payPalShippingAddressOption = .PayPal
        
        
        
        sceneView.autoenablesDefaultLighting = true
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 10)
        sceneView.scene!.rootNode.addChildNode(cameraNode)
        sceneView.pointOfView = cameraNode
        sceneView.allowsCameraControl = true
        
    }
    
    @IBAction func order(sender: UIButton) {
        
       

        let payment = PayPalPayment(amount: 5.00, currencyCode: "GBP", shortDescription: "iPhone5Case", intent: .Sale)
        let shippingAddress = PayPalShippingAddress(recipientName: "Name", withLine1: "line1", withLine2: "", withCity: "City", withState: "State", withPostalCode: "postalCode", withCountryCode: "UK")
        
        payment.shippingAddress = shippingAddress
        
        if payment.processable {
            // If, for example, the amount was negative or the shortDescription was empty, then
            // this payment would not be processable. You would want to handle that here.
            
            
            let paymentViewController =
            
            PayPalPaymentViewController(payment: payment,
                configuration: payPalConfiguration,
                delegate: self)
            
            presentViewController(paymentViewController, animated: true, completion: nil)
        }else{
            print("Payment not processable\(payment)")

        }
       
    }
    
   //MARK: PayPal
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
        
      dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
        
    
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    func verifyCompletedPayment(completedPayment: PayPalPayment){
           // Send the entire confirmation dictionary
//        do {
//            let object = try NSJSONSerialization.dataWithJSONObject(completedPayment.confirmation, options: nil) as! [NSObject : AnyObject]
//            print(object)
//        } catch let error as NSError{
//            
//            print("json error: \(error.localizedDescription)")
//        }
        
            // Send confirmation to your server; your server should verify the proof of payment
        //    // and give the user their goods or services. If the server is not reachable, save
        //    // the confirmation and try again later.
    }
//    - (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
//    // Send the entire confirmation dictionary
//    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
//    options:0
//    error:nil];
//    
//    // Send confirmation to your server; your server should verify the proof of payment
//    // and give the user their goods or services. If the server is not reachable, save
//    // the confirmation and try again later.
//    }
    
    
    
    //MARK: DELEGATE PROTOCOL METHODS
//    func imageViewControllerDidCancel(controller: ImageViewController, didFinishEditingImage editedImage: UIImage) {
//        capturedImage = editedImage
//        
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
//        
//
//    }
    //MARK: IMAGE PICKER
//    @IBAction func takePicture(sender: UIButton) {
//        
//        
//        let actionSheet = UIAlertController(title: "Pick one of the options:", message: "", preferredStyle: .ActionSheet)
//        let actionCamera = UIAlertAction(title: "Camera", style: .Default) { (action) -> Void in
//             //CAMERA
//            if UIImagePickerController .isSourceTypeAvailable(.Camera){
//                
//                let cameraPicker = UIImagePickerController()
//                cameraPicker.delegate = self
//                cameraPicker.allowsEditing = false
//                cameraPicker.sourceType = .Camera
//                
//                
//                
//                self.presentViewController(cameraPicker, animated: true, completion: nil)
//            }
//            else {
//                print("NO CAMERA PRESENTED")
//                let noCamera = UIAlertController(title: "Error", message: "Sorry No Camera Present", preferredStyle: .Alert)
//                let dismissAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
//                noCamera.addAction(dismissAction)
//                self.presentViewController(noCamera, animated: true, completion: nil)
//            }
//            //comment in if you want to use the photos built in or camera
//            
//        }
//        actionSheet.addAction(actionCamera)
//        let actionLibrary = UIAlertAction(title:"Library", style: .Default) { (
//            action) -> Void in
//            //PHOTO GALLERY
//            let libraryPicker = UIImagePickerController()
//            libraryPicker.delegate = self
//            libraryPicker.allowsEditing = false
//            libraryPicker.sourceType = .PhotoLibrary
//            
//            self.presentViewController(libraryPicker, animated: true, completion: nil)
//            
//            
//        }
//        actionSheet.addAction(actionLibrary)
//        
//        self.presentViewController(actionSheet, animated: true, completion: nil)
//        
//        
//        
//        
//        
//    }
//    
//    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        dismissViewControllerAnimated(true, completion: nil)
//    }
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        
//        
//        if let  pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
////            let iphoneMaterial = SCNMaterial()
////            let material001 = SCNMaterial()
////            iphoneMaterial.diffuse.contents = UIImage(named: "iphone-6.jpg")
////            material001.diffuse.contents = pickedImage
//           
//            capturedImage = pickedImage
////            geometryNode.geometry?.materials  = [iphoneMaterial, material001]
//            hasNewImage = true
//            
//            
//            
//        }
//        
//        dismissViewControllerAnimated(true) { () -> Void in
//        
//            
//            
//          self.performSegueWithIdentifier("segue", sender: nil)
//        }
//    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segue"{
            let imageViewController = segue.destinationViewController as! ImageViewController
          //  imageViewController.delegate = self
            imageViewController.newImage = capturedImage
            
            
        }
    }
    func extractIphone6(){
      //  let scene = SCNScene(named: "iPhone 6WithProperCaseVer4")
       
        let scene = SCNScene(named: "Scaled_down_UV_240_4882")
        let emptyScene = SCNScene()
        sceneView!.scene = emptyScene
        
        if let phone = scene!.rootNode.childNodeWithName("Cube", recursively: true){
            let iphoneMaterial = SCNMaterial()
            let material001 = SCNMaterial()
            iphoneMaterial.diffuse.contents = UIImage(named: "iphone-6.jpg")
            
            
            /* UNCOMMENT TO GET DIFFUSE SCREEN and thest if the image is mapped properly
            material001.diffuse.contents = UIImage(named: "Diffuse Screen.jpg")
            
            */
         

            material001.diffuse.contents = capturedImage


            phone.geometry?.materials = [iphoneMaterial]
            let caseNode = phone.childNodeWithName("case", recursively: true)
            caseNode!.geometry?.materials = [material001]
            geometryNode = phone
            geometryNode.position = SCNVector3Make(0, 0, 0)
            
            geometryNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: GLKMathDegreesToRadians(-180), z: 0)
            sceneView.scene!.rootNode.addChildNode(geometryNode)
            
        }
        
            
        
    }
    //MARK: 3D ENVIRONMENT
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
