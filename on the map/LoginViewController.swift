//
//  ViewController.swift
//  on the map
//
//  Created by Guilherme Carvalho on 10/26/15.
//  Copyright © 2015 Guilherme Carvalho. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var auth:Bool = false
    override func viewWillAppear(animated: Bool) {
        msgLabel.hidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton:FBSDKLoginButton = FBSDKLoginButton()
        
        loginButton.center = self.view.center;
        loginButton.center.y -= 50.0
        self.view.addSubview(loginButton);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginTap(sender: AnyObject) {

        let methodParameters: [String: String!] = [
            "username": self.loginField.text,
            "password": self.passwordField.text
        ]
        self.msgLabel.text = ""
        self.msgLabel.hidden = false
        
        GenericClient.self().getSessionID(methodParameters) { (success, results, errorString) in
            if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.msgLabel.text = "Yeah!"
                        let tabBarCtrl = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarCtrl") as! TabViewController
                        self.presentViewController(tabBarCtrl, animated: true, completion: nil)
                    })
            } else {
                    dispatch_async(dispatch_get_main_queue(), {
                            self.msgLabel.text = "Fuck!"
                    })
            }
        }
    }
    
    @IBAction func signUpButtonTouched(sender: AnyObject) {
        let singupURL = NSURL(string: "https://www.udacity.com/account/auth#!/signup")
        UIApplication.sharedApplication().openURL(singupURL!)
        
    }

}

