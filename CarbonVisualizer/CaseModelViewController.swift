import UIKit
import SceneKit
import QuartzCore

class CaseModelViewController: UIViewController, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
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
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
       
        if !hasNewImage{
            extractIphone6()
            
        }
    }
    func extractIphone6(){
        
        //let scene = SCNScene(named:"Case-3") //Case-3 iphone 6plus?
        //     let scene = SCNScene(named: "iPhone6DAE")
        let scene = SCNScene(named: "iPhone6Plus")
        //  let scene = SCNScene(named: "iPhone6")
        let emptyScene = SCNScene()
        sceneView!.scene = emptyScene
        
        if let phone = scene!.rootNode.childNodeWithName("Cube", recursively: true){ //default Cube not Cube2
            let iphoneMaterial = SCNMaterial()
            let material001 = SCNMaterial()
            iphoneMaterial.diffuse.contents = UIImage(named: "iphone-6.jpg")
            
            
            /* UNCOMMENT TO GET DIFFUSE SCREEN and test if the image is mapped properly
             material001.diffuse.contents = UIImage(named: "Diffuse Screen.jpg")
             
             */
            
            1
            material001.diffuse.contents = capturedImage
            
            
            phone.geometry?.materials = [iphoneMaterial]
            let caseNode = phone.childNodeWithName("theCase", recursively: true)
            caseNode!.geometry?.materials = [material001]
            geometryNode = phone
            geometryNode.position = SCNVector3Make(0, 0, 0) //default 0, 0, 0 check 8.7
            
            geometryNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: GLKMathDegreesToRadians(-180), z: 0)
            sceneView.scene!.rootNode.addChildNode(geometryNode)
            
        }
        
        
        
    }
   
    func sendImage(){
        print("calling sendImage function")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //create image instance
        //with image name from bundle
        //let image : UIImage = UIImage(named:"TestImage")! //default if no image
        let imageData = UIImagePNGRepresentation(capturedImage)! //default image
        let imageBase64String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength) as String
        let doneString = imageBase64String.stringByReplacingOccurrencesOfString("+", withString: "%2B")
        
        
        
        //new image items to upload
        //product_code : AJ01039P1 -- for iPhone6 
       //              : AJ01006P -- for iPhone5/5s
        
        
        
        
        let newItem = [
            "product_code"  : "AJ01039P1",        //default was AA01001P   //The product code of the item (from the price list)
            "description"   : "description",        //A customer item description string
            "reference"     : "reference",          //Customer item reference (maybe the internal order number)
            "qty"           : 1,                    //The quantity of this item
            
            "data"          : doneString
        ]
        
        //details JSON for MarvelPress API
        //
        let shippingDict = [                     //The shipping details
            "first_name"    : "Ian",
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
        ]
        let testDict =
            [                     //The shipping details
                "first_name"    : "Ian",
                "last_name"     : "Byland",
                "company"       : "",
                "line_1"        : "3 Corsellis Square",
                "line_2"        : "Nether Lane",
                "town"          : "London",
                "county"        : "Twickenham",
                "country"       : "GB",
                "post_code"     : "TW1 1QT",
                "tel_number"    : "",
                "email"         : "ian@test.test"
        ]
        let details: NSDictionary = [
            "account_code"   : "MP-01546",              //Your account code
            
            "item_count"     : 1,                       //The number of item lines (used to verify all items are received correctly)
            "image_location" : "file",                  //The method used to send the images - file / url, only file is supported
            "items":[newItem],
            "shipping_address"  : [                     //The shipping details
                "first_name"    : "Tony",
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
        //creating header
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = parametersString.dataUsingEncoding(NSUTF8StringEncoding)
        // fire off the request
        //
        // let urlConnection =
       let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) in
            if error == nil{
                let stringData = String(data: data!, encoding: NSUTF8StringEncoding)!
                let stringDataArray = stringData.componentsSeparatedByString("\n")
                
                
                print("Data: \(stringData)")
                print("Data: \(stringDataArray)")
                dispatch_async(dispatch_get_main_queue()) {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            }
            if let error = error{
                print(error.localizedDescription)
                
            }else if let httpResponse = response as? NSHTTPURLResponse{
                if httpResponse.statusCode == 200{
                    
                    print("SUCCESS")
                }else{
                    
                    
                }
                
                
            }
            
           
        }
        dataTask.resume()
        //NSURLSession.sharedSession().dataTaskWithRequest(request).resume()
       
      //  NSURLSession
     //   _ = NSURLConnection(request: request, delegate: self) //DOES THIS NEEDS TO BE HERE ?
     //   check https://www.raywenderlich.com/110458/nsurlsession-tutorial-getting-started
    //    and https://medium.com/swift-programming/learn-nsurlsession-using-swift-ebd80205f87c#.gwgyw7i02
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
        
        sceneView.autoenablesDefaultLighting = true
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 10)
        sceneView.scene!.rootNode.addChildNode(cameraNode)
        sceneView.pointOfView = cameraNode
        sceneView.allowsCameraControl = true
        
    }
    @IBAction func order(sender: UIButton) {
        
        sendImage()
        
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segue"{
            let imageViewController = segue.destinationViewController as! ImageViewController
            imageViewController.newImage = capturedImage
            
            
        }
        if segue.identifier == "orderSegue"{
            
            
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
