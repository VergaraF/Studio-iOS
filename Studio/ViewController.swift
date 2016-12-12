//
//  ViewController.swift
//  Studio
//
//  Created by Fabian Vergara on 2016-12-10.
//  Copyright © 2016 Studio. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import Firebase


class ViewController: UIViewController {

    let loginManager = LoginManager()
    var retrievedUser:FIRUser? = nil

    
    @IBOutlet weak var loginWithFBUIBtn: UIButton!
    
    override func viewDidLoad() {
        
        
        
        if (FBSDKAccessToken.current() != nil) {
            print("you're logged")
            
            hideButton(button: loginWithFBUIBtn, hide: true)
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                // ...
                if let error = error {
                    print("it wasn't possible to login in firebase using FB as the app loaded")
                }
                print("Logged IN FIREBASE!")
                self.retrievedUser = user!
            }
         
        } else {
            print("you're NOT logged")
        }
        

       
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func hideButton(button: UIButton, hide: Bool){
        button.isHidden = hide
    }
    @IBAction func loginWithFBAction(_ sender: Any) {
        
        loginManager.logIn([.publicProfile, .email], viewController: self) { loginResult in
       
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
              //  self.userAccessToken = accessToken
                self.hideButton(button: self.loginWithFBUIBtn, hide: true)
              //  hideButton(button: loginWithFBUIBtn, hide: true)
                
                
                //Create user with info
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    // ...
                    if let error = error {
                        // ...
                        return
                    }
                    print("Logged IN FIREBASE!")

                }
                
                print("Logged in!")
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    


}

