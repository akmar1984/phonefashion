//
//  ExampleViewController.swift
//  PhoneFashionApp
//
//  Created by Marek Tomaszewski on 25/11/2015.
//
//

import UIKit

class ExampleViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: KaedeTextField!
    
    @IBOutlet weak var lastNameTextField: KaedeTextField!
    
    @IBOutlet weak var addressLineOneTextField: KaedeTextField!
    
    @IBOutlet weak var addressLineTwoTextField: KaedeTextField!
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //try using textfield inside the cell!

        
        
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
