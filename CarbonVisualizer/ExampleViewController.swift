//
//  ExampleViewController.swift
//  PhoneFashionApp
//
//  Created by Marek Tomaszewski on 25/11/2015.
//
//

import UIKit

class ExampleViewController: UIViewController {
    var overlay: UIView!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        createOverlay()
        transparentOverlay()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    func createOverlay(){
        let offset: CGFloat = 40.0
        let overlayFrame = CGRectMake(offset, offset, view.bounds.size.width - offset * 2, view.bounds.size.height - offset * 2)
        overlay = UIView(frame: overlayFrame)
        overlay.backgroundColor = UIColor.redColor()

        overlay.userInteractionEnabled = false
        // view.addSubview(overlay)
    }
    func transparentOverlay(){
        
        let path = UIBezierPath(roundedRect: CGRectMake(0, 0, view.bounds.width, view.bounds.height), cornerRadius: 0)
        let rect = UIBezierPath(rect: CGRectMake(50, 50, overlay.bounds.width, overlay.bounds.height))
        path.usesEvenOddFillRule = true
        path.appendPath(rect)

        let fillLayer = CAShapeLayer()
        fillLayer.path = path.CGPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = UIColor.blackColor().CGColor
        fillLayer.opacity = 1.0
        view.layer.addSublayer(fillLayer)
        
        
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
