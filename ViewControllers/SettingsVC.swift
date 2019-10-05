//
//  SettingsVC.swift
//  SnapchatClone
//
//  Created by Erhan Acisu on 5.10.2019.
//  Copyright © 2019 Emirhan Acisu. All rights reserved.
//

import UIKit
import  Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutClicked(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignInVC", sender: nil)
        }
        catch{
            
        }
        
    }
    

}
