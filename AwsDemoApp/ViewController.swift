//
//  ViewController.swift
//  AwsDemoApp
//
//  Created by Abdoulaye Diallo on 11/5/18.
//  Copyright © 2018 224Apps. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSAuthUI

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    //Action for the Log Out Button
    @IBAction func LogOut(_ sender: UIButton) {
        AWSSignInManager.sharedInstance().logout(completionHandler: { (value, error) in
            self.checkForUserLogin()
        })
    }
    
    //Check if the user is logged in
    func checkForUserLogin()  {
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            AWSAuthUIViewController.presentViewController(with: self.navigationController!, configuration: nil) { (provider, error) in
                if  error == nil {
                    print("success")
                }
                else {
                    print(error.debugDescription)
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Check if the user in logged in
        checkForUserLogin()
    }
    
    
}

