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
import SCLAlertView



class ViewController: UIViewController, UITextFieldDelegate {
   
    
    let loginManager = LoginManager()
    let iphoneFiveYMax = 568
    
    @IBOutlet var regularLoginBtn  : UIButton!
    @IBOutlet var loginWithFBUIBtn : UIButton!
    @IBOutlet var singUpBtn        : UIButton!
    @IBOutlet var backButton       : UIButton!
    
    var oldSignUpBtnBackgroundColour = UIColor()
    var oldSignUpBtnTitle            = String()
    var oldSignUpBtnTitleColour      = UIColor()
    
    @IBOutlet var emailTextField           : UITextField!
    @IBOutlet var passwordTextfield        : UITextField!
    @IBOutlet var confirmPasswordTextfield : UITextField!
    
    @IBOutlet var appnameLabel : UILabel!
    @IBOutlet var errorPrompt  : UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate           = self
        self.passwordTextfield.delegate        = self
        self.confirmPasswordTextfield.delegate = self
        
        oldSignUpBtnBackgroundColour = singUpBtn.backgroundColor!
        oldSignUpBtnTitle            = singUpBtn.title(for: .normal)!
        oldSignUpBtnTitleColour      = singUpBtn.titleColor(for: .normal)!
        
        
        /*if (FBSDKAccessToken.current() != nil) {
            print("you're logged")
            
            hideButton(button: loginWithFBUIBtn, hide: true)
            hideButton(button: regularLoginBtn,  hide: true)
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
         @IBAction func backButtonAction(_ sender: Any) {
         }
            
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
         */

       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
        }
    }
    
    func signedIn(_ user: FIRUser?) {
        
        UserDefaults.standard.set(user?.displayName, forKey: "username")
        UserDefaults.standard.set(user?.uid, forKey: "uid")
        
        //Get from API if user is tutor 
        
        
      /*  MeasurementHelper.sendLoginEvent()
        
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoURL = user?.photoURL
        AppState.sharedInstance.signedIn = true */
 
        let notificationName = Notification.Name(rawValue: "You're signed in")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
       // performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
    }
    
    private func hideButton(button: UIButton, hide: Bool){
        button.isHidden = hide
    }
    
    private func goBack(){
        hideButton(button: loginWithFBUIBtn, hide: false)
        hideButton(button: singUpBtn, hide: false)
        hideButton(button: regularLoginBtn, hide: false)
        hideButton(button: backButton, hide: true)
        
        emailTextField.isHidden           = true
        passwordTextfield.isHidden        = true
        confirmPasswordTextfield.isHidden = true
        
        if (regularLoginBtn.tag == 1 || singUpBtn.tag == 1){
            errorPrompt.isHidden = true

        }else{
            errorPrompt.isHidden = false

        }
        
        regularLoginBtn.setTitle("Login", for: .normal)
        
        passwordTextfield.text        = ""
        confirmPasswordTextfield.text = ""
        emailTextField.text           = ""
        
        singUpBtn.backgroundColor = oldSignUpBtnBackgroundColour
        singUpBtn.setTitleColor(oldSignUpBtnTitleColour, for: .normal)
        singUpBtn.setTitle(oldSignUpBtnTitle, for: .normal)
        
        regularLoginBtn.tag = 0
        singUpBtn.tag       = 0

    }
    @IBAction func regularLoginAction(_ sender: Any) {
        print("regular login")
        
        emailTextField.isHidden    = false
        passwordTextfield.isHidden = false
        hideButton(button: backButton, hide: false)

        let alert = SCLAlertView()

        switch (sender as! UIButton).tag {
        case 0:
            hideButton(button: loginWithFBUIBtn, hide: true)
            hideButton(button: singUpBtn, hide: true)
            self.errorPrompt.isHidden = true
            regularLoginBtn.setTitle("GO", for: .normal)

            (sender as! UIButton).tag = 1


            break;
        case 1:
            (sender as! UIButton).tag = 0
            if ((emailTextField.text != nil || emailTextField.text != "") && (passwordTextfield.text != nil || passwordTextfield.text != "")){
                FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextfield.text!) { (user, error) in
                    if (error != nil){
                        //(sender as! UIButton).tag = 0
                        
                        print("There was a problem authenticating given user. Perhaps it doesnt exist, or password/email is incorrent")
                        
                        self.emailTextField.text = ""
                        self.passwordTextfield.text = ""
                        self.errorPrompt.text = "The email or password entered is incorrect. It could also be that the user doesn't exist."
                        self.errorPrompt.isHidden = false
                        self.goBack()
                        self.hideButton(button: self.backButton, hide: true)
                        
                        alert.showError("Something went wrong :(", subTitle: "The email or password entered is incorrect. It could also be that the user doesn't exist. Please try again.")

                        return
                    }
                    
                    self.hideButton(button: self.backButton, hide: true)

                    UserDefaults.standard.set(user?.displayName, forKey: "username")
                    UserDefaults.standard.set(user?.uid, forKey: "uid")
                }

            }else{
                print("no empty email or password is allowed")
                alert.showError("Something went wrong :(", subTitle: "No empty email or password is allowed. Pleasy try again.")
            }
            


            break;
        default:
            print("aayy")
        }
        

        
    }
    
    
    @IBAction func loginWithFBAction(_ sender: Any) {
        
        let alert = SCLAlertView()

        
        loginManager.logIn([.publicProfile, .email], viewController: self) { loginResult in
       
            switch loginResult {
                
            case .failed(let error):
                print(error)
                
                alert.showError("Something went wrong :(", subTitle: "You need to authorize Studio to access your Facebook information. Try again.")
               
                self.errorPrompt.text = "There was an error. You need to authorize Studio to access your Facebook information. Try again."
                self.errorPrompt.isHidden = false
                self.goBack()
                
            case .cancelled:
                alert.showError("Something went wrong :(", subTitle: "It seems you cancelled login. You need to authorize Studio to access your Facebook information. Try again.")
                
                print("User cancelled login.")
                self.errorPrompt.text = "There was an error. You need to authorize Studio to access your Facebook information. Try again."
                self.errorPrompt.isHidden = false
                self.goBack()
                
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                
                self.hideButton(button: self.loginWithFBUIBtn, hide: true)
                self.hideButton(button: self.regularLoginBtn,  hide: true)
                self.hideButton(button: self.backButton, hide: true)


                
                //Create user with info
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    if error != nil {
                        print("there was an error authenticating in firebase")
                        return
                    }
                    self.hideButton(button: self.backButton, hide: true)

                    print("Logged IN FIREBASE using Login With Facebook!")
                    if UserDefaults.standard.object(forKey: "uid") != nil{
                        print("move on, the guy is just loggin again. NOT for the first time")
                        
                        alert.showSuccess("Welcome back", subTitle: "You will be taken to our tutors hub shortly")

                        //SEGUEY TO TUTOR CARDS
                        
                    }else{
                        
                        UserDefaults.standard.set(user?.displayName, forKey: "username")
                        UserDefaults.standard.set(user?.uid, forKey: "uid")
                        
                        //Segue to ARE YOU A TUTOR OR STUDENT VIEW?
                        
                        UserDefaults.standard.set(false, forKey: "isTutor")
                        
                        //SEGUEY to choose whether the user is a TUTOR or STUDENT
                    }
                    
                }
                
            }
        }
    }
    
    
    
    @IBAction func signUpAction(_ sender: Any) {
        hideButton(button: backButton, hide: false)

        hideButton(button: loginWithFBUIBtn, hide: true)
        hideButton(button: regularLoginBtn, hide: true)
        
        errorPrompt.isHidden = false
        
        let alert = SCLAlertView()
        
        switch (sender as! UIButton).tag {
        case 0:
            emailTextField.isHidden           = false
            passwordTextfield.isHidden        = false
            confirmPasswordTextfield.isHidden = false
            
            singUpBtn.setTitle("GO", for: .normal)
            singUpBtn.backgroundColor = regularLoginBtn.backgroundColor
            singUpBtn.setTitleColor(UIColor.white, for: .normal)
            
            (sender as! UIButton).tag = 1
            
            errorPrompt.isHidden = true
            
            break;
            
        case 1:
           // singUpBtn = oldSignUpBtn

            if (passwordTextfield.text != nil && confirmPasswordTextfield.text != nil && emailTextField.text != nil ){
                if (passwordTextfield.text != confirmPasswordTextfield.text){
                    
                    alert.showError("Something went wrong :(", subTitle: "You must enter the same password twice. Please try again.")
                    
                    errorPrompt.text = "You must enter the same password twice. Please try again."
                    passwordTextfield.text = ""
                    confirmPasswordTextfield.text = ""
                    errorPrompt.isHidden = false
                    break
                }else{
                    FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextfield.text!) { (user, error) in
                        if (error != nil){
                            
                            alert.showError("Something went wrong :(", subTitle: "The email already exists OR it is not a valid email. \n\nIf you already registered, please log in instead. If not, use another email. \n\nIf you're the legit owner of this email address, contact our team.")

                            print("something went wrong creating the user, perhaps the email already exists")
                            
                            //self.errorPrompt.isHidden = false
                            return
                        }
                        //Everything went smooth
                        self.hideButton(button: self.backButton, hide: true)

                        print("user created and logged in")
                        UserDefaults.standard.set(user?.displayName, forKey: "username")
                        UserDefaults.standard.set(user?.uid, forKey: "uid")
                        
                        //Segue to ARE YOU A TUTOR OR STUDENT VIEW?
                        
                        UserDefaults.standard.set(false, forKey: "isTutor")
                        
                        //SEGUEY to choose whether the user is a TUTOR or STUDENT
                    }
                }
                
            }else{
                
                alert.showError("Something went wrong :(", subTitle: "You cannot leave any field empty. Please try again with a valid input.")
                
                errorPrompt.text = "You cannot leave any field empty. Please try again with a valid input."
                errorPrompt.isHidden = false
                
                break
            }
            
        default:
            print("signing up ayyyy")
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        goBack()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{

        let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField
        if nextField != nil{
            if nextField?.tag == 22 && singUpBtn.tag == 0{
                print("resigning first responder")
                textField.resignFirstResponder()
                return true
            }
            print("next first responder found")
            nextField?.becomeFirstResponder()
            return true
        }
       
            // Not found, so remove keyboard.
            print("resigning first responder")
            textField.resignFirstResponder()
    
        // Do not add a line break
     
        return true
    }

}

