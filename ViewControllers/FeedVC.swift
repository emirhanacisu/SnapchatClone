//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Erhan Acisu on 5.10.2019.
//  Copyright © 2019 Emirhan Acisu. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let fireStoreDatabase = Firestore.firestore()
    var snapArray = [Snap]()
    var chosenSnap : Snap?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getSnapFromFirebase()
        getUserInfo()
      
    }
    
    func getSnapFromFirebase(){
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "error")
            }
            else{
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    self.snapArray.removeAll(keepingCapacity: false)
                   
                    
                    for document in snapshot!.documents{
                        let documentId = document.documentID
                        
                        if let userName = document.get("snapOwner") as? String{
                            if let imageUrlArray = document.get("imageUrlArray") as? [String]{
                                if let date = document.get("date") as? Timestamp {
                                  
                                    if let difference  = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour{
                                        if difference >= 24 {
                                            self.fireStoreDatabase.collection("Snaps").document(documentId).delete { (error) in
                                                
                                            }
                                            
                                        }
                                            
                                        else{
                                           let snap = Snap(userName: userName, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: 24 - difference)
                                           self.snapArray.append(snap)
                                            
                                        }
                                        
                                        }
                                        
                                    }
                                    
                            
                            
                            }
                        }
                        
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    

    func getUserInfo(){
    
         fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
         if error != nil {
             self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
         } else {
             if snapshot?.isEmpty == false && snapshot != nil {
                 for document in snapshot!.documents {
                     if let username = document.get("userName") as? String {
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.feedUserNameLabel.text = snapArray[indexPath.row].userName
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC"{
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap = chosenSnap
           // destinationVC.selectedTime = self.timeLeft
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
}
