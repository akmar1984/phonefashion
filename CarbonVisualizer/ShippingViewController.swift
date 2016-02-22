//
//  ExampleViewController.swift
//  PhoneFashionApp
//
//  Created by Marek Tomaszewski on 25/11/2015.
//
//

import UIKit

class ShippingViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: KaedeTextField!
    @IBOutlet weak var lastNameTextField: KaedeTextField!
    @IBOutlet weak var addressLineOneTextField: KaedeTextField!
    @IBOutlet weak var addressLineTwoTextField: KaedeTextField!
    @IBOutlet weak var countryTextField: KaedeTextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    

    var countryCode: String!

    var pickerView: UIPickerView!
    var pickerData: [String] = [String]()
    var shortCountryCodeArray: [String] = [String]()

    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        pickerConf()
        
        getCountryName()
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "shippingSegue"{
            
            
            let navigationController = segue.destinationViewController as! UINavigationController
            
            let controller = navigationController.topViewController as! ShippingSummaryViewController
            
            controller.label = countryTextField.text!
            
            
        }
        
    }
    @IBAction func cancelButtonBar(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func pickerConf(){
        pickerView = UIPickerView.init(frame: CGRectMake(0, view.bounds.height - 300, 600, 300))
        pickerView.backgroundColor = UIColor.clearColor()
        countryTextField.placeholder = "Country"
        countryTextField.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        countryTextField.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.frame = CGRectMake(pickerView.frame.origin.x, pickerView.frame.origin.y , 100, 100)
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "donePicker")
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelPicker")
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        countryTextField.inputAccessoryView = toolBar
        
        
    }
    func donePicker(){
        countryCode = countryTextField.text
        countryTextField.resignFirstResponder()
        
    }
    func cancelPicker(){
        countryTextField.text = ""
        countryCode = ""
        countryTextField.resignFirstResponder()
    }
    
    
    func getCountryName(){
        pickerData = NSLocale.ISOCountryCodes()
        
        let locale = NSLocale.currentLocale()
        var sortedCountryArray: [String] = []
        var shortCountryArray: [String] = []
        
        
        for countryCode in pickerData{
            
            let displayName = locale.displayNameForKey(NSLocaleCountryCode, value: countryCode)
            sortedCountryArray.append(displayName!)
            
        }
        for countryShortCode in pickerData{
            shortCountryArray.append(countryShortCode)
        }
        pickerData = sortedCountryArray
        shortCountryCodeArray = shortCountryArray
    }
    
    //The numbers of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
        
    }
    //The numbers of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerData.count
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        countryTextField.text = shortCountryCodeArray[row]
        
        
    }
    
    
    //the title to use as the title of the component data
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
        
    }
    
    
    // Do any additional setup after loading the view.
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
