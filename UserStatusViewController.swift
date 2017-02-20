//
//  isTutorOrStudentViewController.swift
//  Studio
//
//  Created by Fabian Vergara on 2017-02-18.
//  Copyright © 2017 Studio. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import Firebase
import SCLAlertView

class UserStatusViewController: UIViewController{
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
    }
    
    //tag 0 for tutor. Tag 1 for student
    
    @IBAction func isUserTutorOrStudentAction(_ sender: Any) {
        switch ( (sender as! UIButton).tag){
        case 0:
            print("tutor")
            UserDefaults.standard.set(true, forKey: "isTutor")
            //go to tutor panel control
//            break
        case 1:
            print("student")
            UserDefaults.standard.set(false, forKey: "isTutor")
            self.performSegue(withIdentifier: "goToSubjectsForFirstTime", sender: self)

//            break
        default:
            print("none")
        }
    }
}
