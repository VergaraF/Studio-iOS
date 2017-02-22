//
//  ClassesController.swift
//  Studio
//
//  Created by Fabian Vergara on 2017-02-21.
//  Copyright © 2017 Studio. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import Firebase
import SCLAlertView

class StudentSubjectsController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Handle the text field’s user input through delegate callbacks.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Subjects"
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
       // let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "SubjectCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as! SubjectCell

       // let cell = SubjectCell(style: UITableViewCellStyle.default, reuseIdentifier: "SubjectCell")
        
        cell.cellUIImage.image = UIImage(named: "menu.png")
        
       // cell.cellUIImage = UIImageView(UIImage(named: "menu-32.png"))
       
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColor.cyan

        }
        
        return cell
    }
    
    //TODO
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    
}
