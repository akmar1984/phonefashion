import UIKit
import SceneKit


class CaseModelViewController: UIViewController, PayPalPaymentDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
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
            extractIphone6()
            
        }
    }
    
    
    func sendImage(){
        //create image instance
        //with image name from bundle
        let image : UIImage = UIImage(named:"TestImage")!
        let imageData = UIImagePNGRepresentation(image)!
        let imageBase64String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength) as String
        let doneString = imageBase64String.stringByReplacingOccurrencesOfString("+", withString: "%2B")
        
        //create header
        //
    //    let requestHeaders = [
    //        "Content-Type": "application/x-www-form-urlencoded"
     //   ]
        
        //new image items to upload
        //
        let newItem = [
            "product_code"  : "AA01001P",           //The product code of the item (from the price list)
            "description"   : "description",        //A customer item description string
            "reference"     : "reference",          //Customer item reference (maybe the internal order number)
            "qty"           : 1,                    //The quantity of this item
            
            "data"          : doneString
        ]
        
        //details JSON for MarvelPress API
        //
        let details: NSDictionary = [
            "account_code"   : "MP-01546",              //Your account code
            
            "item_count"     : 1,                       //The number of item lines (used to verify all items are received correctly)
            "image_location" : "file",                  //The method used to send the images - file / url, only file is supported
            "items":[newItem],
            "shipping_address"  : [                     //The shipping details
                "first_name"    : "Oliver",
                "last_name"     : "Smith",
                "company"       : "Marvelpress Ltd",
                "line_1"        : "13a Provincial Park",
                "line_2"        : "Nether Lane",
                "town"          : "Salt Lake City",
                "county"        : "Yorkshire",
                "country"       : "GB",
                "post_code"     : "84120",
                "tel_number"    : "01142454494",
                "email"         : "test@test.test"
            ],
            
            "shipping_method" : "RM1"                   //The shipping method code (From table in documentation)
        ]
        
        //convert details dictionary to JSON string
        //
        var detailsJSON: String = ""
        let detailsData = try? NSJSONSerialization.dataWithJSONObject(details, options: NSJSONWritingOptions.PrettyPrinted)
        
        if let detailsData = detailsData {
            if let json = NSString(data: detailsData, encoding: NSUTF8StringEncoding) {
                
                detailsJSON = json as String
            }
        }
        
        //create credential
        //
        let user       = "MP-01546/phonefashion"
        let password   = "ff50811f067dbba16f9682dba9b08f93"
        
        
        let loginString = NSString(format: "%@:%@", user, password)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = loginData.base64EncodedStringWithOptions([])
        
        let parametersString = String(format: "details=%@&%@", arguments: [detailsJSON, "debug=true"])
        
        // create the request
        let request = NSMutableURLRequest(URL: NSURL(string:"https://orders.marvelpress.co.uk/orders/order/")!)
        request.HTTPMethod = "POST"
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = parametersString.dataUsingEncoding(NSUTF8StringEncoding)
        // fire off the request
        //
        let urlConnection = NSURLConnection(request: request, delegate: self)
        
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse){
        
        debugPrint("response: %@", response)
        
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData){
        
        let responseData = String(data: data, encoding: NSUTF8StringEncoding)
        
        debugPrint(responseData)
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
        
        //handle the payments confirmation!!
//                do {
//                    let object = try NSJSONSerialization.dataWithJSONObject(completedPayment.confirmation, options: nil) as! [NSObject : AnyObject]
//                    print(object)
//                } catch let error as NSError{
//        
//                    print("json error: \(error.localizedDescription)")
//                }
        
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
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segue"{
            let imageViewController = segue.destinationViewController as! ImageViewController
            imageViewController.newImage = capturedImage
            
            
        }
    }
    func extractIphone6(){
        
        
        //let scene = SCNScene(named: "Scaled_down_UV_240_4882")
        let scene = SCNScene(named: "case_with_applied_modifiers_V3-3") //CHECK if the dimensions of the obramowania testowego sie zgadzaja
        let emptyScene = SCNScene()
        sceneView!.scene = emptyScene
        
        if let phone = scene!.rootNode.childNodeWithName("Cube", recursively: true){
            let iphoneMaterial = SCNMaterial()
            let material001 = SCNMaterial()
            iphoneMaterial.diffuse.contents = UIImage(named: "iphone-6.jpg")
            
            
            /* UNCOMMENT TO GET DIFFUSE SCREEN and test if the image is mapped properly
            material001.diffuse.contents = UIImage(named: "Diffuse Screen.jpg")
            
            */
            
            
            material001.diffuse.contents = capturedImage
            
            
            phone.geometry?.materials = [iphoneMaterial]
            let caseNode = phone.childNodeWithName("theCase", recursively: true)
            caseNode!.geometry?.materials = [material001]
            geometryNode = phone
            geometryNode.position = SCNVector3Make(0, 0, 0)
            
            geometryNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: GLKMathDegreesToRadians(-180), z: 0)
            sceneView.scene!.rootNode.addChildNode(geometryNode)
            
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
