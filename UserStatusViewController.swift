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
    
    @IBAction func isTutorOrStudentAction(_ sender: UIButton) {
        print(sender.tag)
        switch ( sender.tag){
        case 0:
            print("tutor")
            UserDefaults.standard.set(true, forKey: "isTutor")
            //go to tutor panel control
        //            break
        case 1:
            print("student")
            UserDefaults.standard.set(false, forKey: "isTutor")
            self.performSegue(withIdentifier: "goToSubjectForFirstTime", sender: self)
            
        //            break
        default:
            print("none")
        }

    }

}
