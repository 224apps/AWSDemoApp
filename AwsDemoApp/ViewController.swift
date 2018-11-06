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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
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
    
    
}

