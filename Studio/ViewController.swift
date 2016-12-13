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
    let iphoneFiveYMax = 568
    
    @IBOutlet var regularLoginBtn : UIButton!
    @IBOutlet var loginWithFBUIBtn: UIButton!
    @IBOutlet var singUpBtn       : UIButton!
    
    @IBOutlet var emailTextField   : UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet var appnameLabel: UILabel!

    
    override func viewDidLoad() {
        

        print(self.view.bounds.maxY)

        if (FBSDKAccessToken.current() != nil) {
            print("you're logged")
            
            hideButton(button: loginWithFBUIBtn, hide: true)
            hideButton(button: regularLoginBtn,  hide: true)
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                if let error = error {
                    print("it wasn't possible to login in firebase using Facebook as the app loaded")
                }
                //SEGUE TO TUTOR CARDS
                print("Logged IN FIREBASE automatically!")
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
    @IBAction func regularLoginAction(_ sender: Any) {
        
        
        
        print("regular login")
        
        emailTextField.isHidden = false
        passwordTextfield.isHidden = false


        switch (sender as! UIButton).tag {
        case 0:
            (sender as! UIButton).tag = 1
            if self.view.bounds.maxY < 600{
                print("true")
                self.appnameLabel.center = CGPoint(x: self.appnameLabel.center.x, y: self.appnameLabel.center.y - 100)
            }

            break;
        case 1:
            break;
        default:
            print("aayy")
        }
        
        hideButton(button: loginWithFBUIBtn, hide: true)

        
    }
    @IBAction func loginWithFBAction(_ sender: Any) {
        
        loginManager.logIn([.publicProfile, .email], viewController: self) { loginResult in
       
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                
                self.hideButton(button: self.loginWithFBUIBtn, hide: true)
                self.hideButton(button: self.regularLoginBtn,  hide: true)

                
                //Create user with info
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    if error != nil {
                        print("there was an error authenticating in firebase")
                        return
                    }
                    print("Logged IN FIREBASE using Login With Facebook!")
                    if UserDefaults.standard.object(forKey: "uid") != nil{
                        print("move on, the guy is just loggin again. NOT for the first time")
                        //SEGUEY TO TUTOR CARDS
                        
                    }else{
                        UserDefaults.standard.set(user?.displayName, forKey: "username")
                        UserDefaults.standard.set(user?.uid, forKey: "uid")
                        UserDefaults.standard.set(false, forKey: "isTutor")
                        
                        //SEGUEY to choose whether the user is a TUTOR or STUDENT
                    }
                    
                }
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    


}

