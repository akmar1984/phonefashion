/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
   
       // PayPalMobile.initializeWithClientIdsForEnvironments([ PayPalEnvironmentNoNetwork : "NoNetwork", PayPalEnvironmentSandbox : "Client Sandbox Id"])
        PayPalMobile.initializeWithClientIdsForEnvironments([ PayPalEnvironmentProduction : "Your client id",
            PayPalEnvironmentSandbox : "AXoyWlS7bt9aPdo6NK04cvSKVHJEQoiVNMhk3ifSOtAO01i0xQAu_yexa4a6-bzSXEwCcdSv_suV-laX"])
        
        //PayPalEnvironmentSandbox : "AXoyWlS7bt9aPdo6NK04cvSKVHJEQoiVNMhk3ifSOtAO01i0xQAu_yexa4a6-bzSXEwCcdSv_suV-laX"]
        
    return true
   
  }
}
