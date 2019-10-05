//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Erhan Acisu on 5.10.2019.
//  Copyright © 2019 Emirhan Acisu. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let fireStoreDatabase = Firestore.firestore()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfo()
    }
    

    func getUserInfo(){
    
        self.fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
            if error != nil{
                self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "Error")
            }
            else{
                if snapshot?.isEmpty == false && snapshot != nil {
                    for documents in snapshot!.documents{
                        if let username =  documents.get("username") as? String{
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    func makeAlert(titleInput : String, messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
