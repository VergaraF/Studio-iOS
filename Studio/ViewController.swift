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


class ViewController: UIViewController, UITextFieldDelegate {
   
    
    let loginManager = LoginManager()
    let iphoneFiveYMax = 568
    
    @IBOutlet var regularLoginBtn : UIButton!
    @IBOutlet var loginWithFBUIBtn: UIButton!
    @IBOutlet var singUpBtn       : UIButton!
    
    @IBOutlet var emailTextField   : UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var confirmPasswordTextfield: UITextField!
    
    @IBOutlet var appnameLabel: UILabel!
    @IBOutlet var errorPrompt: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate    = self
        self.passwordTextfield.delegate = self
        

        print(self.view.bounds.maxY)

        if (FBSDKAccessToken.current() != nil) {
            print("you're logged")
            
            hideButton(button: loginWithFBUIBtn, hide: true)
            hideButton(button: regularLoginBtn,  hide: true)
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                if error != nil {
                    print("it wasn't possible to login in firebase using Facebook as the app loaded")
                }
                //SEGUE TO TUTOR CARDS
                print("Logged IN FIREBASE automatically!")
            }
         
        } else {
            print("you're NOT logged")
        }
        

       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func hideButton(button: UIButton, hide: Bool){
        button.isHidden = hide
    }
    @IBAction func regularLoginAction(_ sender: Any) {
        print("regular login")
        
        emailTextField.isHidden    = false
        passwordTextfield.isHidden = false


        switch (sender as! UIButton).tag {
        case 0:
            
            if self.view.bounds.maxY < 600{
                print("true")
               // self.appnameLabel.center = CGPoint(x: self.appnameLabel.center.x, y: self.appnameLabel.center.y - 140)
            }else{
              //  self.appnameLabel.center = CGPoint(x: self.appnameLabel.center.x, y: self.appnameLabel.center.y - 80)

            }
            hideButton(button: loginWithFBUIBtn, hide: true)
            hideButton(button: singUpBtn, hide: true)
            self.errorPrompt.isHidden = true

            (sender as! UIButton).tag = 1


            break;
        case 1:
            (sender as! UIButton).tag = 0
            if ((emailTextField.text != nil || emailTextField.text != "") && (passwordTextfield.text != nil || passwordTextfield.text != "")){
                FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextfield.text!) { (user, error) in
                    if (error != nil){
                        //(sender as! UIButton).tag = 0
                        print("There was a problem authenticating given user. Perhaps it doesnt exist, or password/email is incorrent")
                        self.hideButton(button: self.loginWithFBUIBtn, hide: false)
                        self.hideButton(button: self.singUpBtn, hide: false)
                        self.emailTextField.isHidden    = true
                        self.passwordTextfield.isHidden = true
                        self.emailTextField.text = ""
                        self.passwordTextfield.text = ""
                        self.errorPrompt.text = "The email or password entered is incorrect. It could also be that the user doesn't exist. Please try again."
                        self.errorPrompt.isHidden = false
                        return
                    }
                    
                    UserDefaults.standard.set(user?.displayName, forKey: "username")
                    UserDefaults.standard.set(user?.uid, forKey: "uid")
                }

            }else{
                print("no empty email or password is allow")
            }
            


            break;
        default:
            print("aayy")
        }
        

        
    }
    @IBAction func loginWithFBAction(_ sender: Any) {
        
        loginManager.logIn([.publicProfile, .email], viewController: self) { loginResult in
       
            switch loginResult {
            case .failed(let error):
                print(error)
                self.errorPrompt.text = "There was an error. You need to authorize Studio to access your Facebook information. Try again."
                self.errorPrompt.isHidden = false
            case .cancelled:
                print("User cancelled login.")
                self.errorPrompt.text = "There was an error. You need to authorize Studio to access your Facebook information. Try again."
                self.errorPrompt.isHidden = false
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
     

        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            print("next first responder found")
            
            nextField.becomeFirstResponder()
            
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
     
        return true
    }
    
    
    
    


}

