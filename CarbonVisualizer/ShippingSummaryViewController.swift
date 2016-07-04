//
//  ShippingSummaryViewController.swift
//  PhoneFashionApp
//
//  Created by Marek Tomaszewski on 22/02/2016.
//
//

import UIKit

class ShippingSummaryViewController: UITableViewController, PayPalPaymentDelegate {

    

    var emailAddress: String!
    var firstName: String!
    var lastName: String!
    var country: String!
    
    
    //Paypal
    var totalAmount = NSDecimalNumber()
    var payPalConfiguration =  PayPalConfiguration()
    
    
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

//        emailAddressLabel.text = emailAddress
//        firstNameLabel.text = firstName
//        lastNameLabel.text = lastName
//        countryLabel.text = country //uncomment for the summary
        
         configurePayPal()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
         PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentSandbox)
        
    }
    
    @IBAction func proceedToPayment1(sender: UIBarButtonItem) {
        startPaypal()
    }
    @IBAction func proceedToPayment(sender: UIButton) {
        startPaypal()
        
        
        
    }
   
    
    
    
    func configurePayPal(){
        
        // Set up payPalConfig
        payPalConfiguration.acceptCreditCards = true
        payPalConfiguration.payPalShippingAddressOption = .PayPal
        payPalConfiguration.acceptCreditCards = false
        payPalConfiguration.merchantName = "FashionPhoneTEST"
        payPalConfiguration.merchantPrivacyPolicyURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfiguration.merchantUserAgreementURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        payPalConfiguration.languageOrLocale = NSLocale.preferredLanguages()[0]
        
        payPalConfiguration.payPalShippingAddressOption = .PayPal;
        
        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
        
        
    }
    func startPaypal(){
        print("Starting paypal")
        totalAmount = 5.00
        let payment = PayPalPayment(amount: totalAmount, currencyCode: "GBP", shortDescription: "iPhone5CasePrint", intent: .Sale)
        let shippingAddress = PayPalShippingAddress(recipientName: "Name", withLine1: "line1", withLine2: "", withCity: "City", withState: "State", withPostalCode: "postalCode", withCountryCode: "UK")
        
        payment.shippingAddress = shippingAddress
        
        if payment.processable {
            
            
            
            let paymentViewController =
            
            PayPalPaymentViewController(payment: payment,
                configuration: payPalConfiguration,
                delegate: self)
            
            presentViewController(paymentViewController, animated: true, completion: nil)
        }else{
            
            // If, for example, the amount was negative or the shortDescription was empty, then
            // this payment would not be processable. You would want to handle that here.
            print("Payment not processable\(payment)")
            
        }
        
    }
    //MARK: PayPal
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
        
        print("Payment processed succesfully:\(completedPayment.confirmation)")
        
       
        let paymentConfirmation = completedPayment.confirmation as NSDictionary
           // print(paymentConfirmation.objectForKey("response"))
        let responseDict = paymentConfirmation["response"] as! NSDictionary
        let state = responseDict["state"]
        print("Here's the state: \(state!)")
        
        
//        if let resultDic = dicResult["response"] as? [String : String]{
//            let state = resultDic["state"]
//            print("State is: \(state)")
//        }
        sendPaymentConfirmationToServer(completedPayment.confirmation);
       // dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func sendPaymentConfirmationToServer(confirmation: NSDictionary) {
        let foundationDictionary = NSMutableDictionary(dictionary: confirmation)
        foundationDictionary["amount"] = totalAmount
        
        let strServerUrl = "http://52.31.103.182"
        
        let manager = AFHTTPSessionManager();
        manager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html", "text/json", "application/json"]) as? Set<String>
        
        SVProgressHUD.showWithStatus("Sending Payment Confirmation...")
        manager.POST(strServerUrl, parameters: foundationDictionary,
            progress: { (progress) -> Void in
                
            },
            success: { (sessionTask, response) -> Void in
                let dicResult = response as! NSDictionary
                print(response)
                
               
                if(dicResult["result"]?.boolValue == true) {
                    SVProgressHUD.showSuccessWithStatus("Payment Successful")
                    
                    
                    //SVProgressHUD.showSuccessWithStatus(dicResult["message"] as! String) //uncomment for dev purposes
                    print("dictResult boolValue == true")
                  //  self.performSelector(#selector(self.goHomeScreen), withObject: self, afterDelay: 2.0)
                    
                } else {
                    SVProgressHUD.showErrorWithStatus(dicResult["message"] as! String)
                }
                
            }) { (sessionTask, error) -> Void in
                SVProgressHUD.showErrorWithStatus(error.localizedDescription)
        }
    }
    func goHomeScreen(){
        
        performSegueWithIdentifier("unwindSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBarButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
