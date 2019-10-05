//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Erhan Acisu on 5.10.2019.
//  Copyright © 2019 Emirhan Acisu. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if  passwordText.text != "" && mailText.text != "" {
        
            Auth.auth().signIn(withEmail: self.mailText.text!, password: self.passwordText.text!) { (result, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }
        else{
              self.makeAlert(titleInput: "Error", messageInput: "Boşlukları Doldurunuz")
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if userNameText.text != "" && passwordText.text != "" && mailText.text != "" {
            
            Auth.auth().createUser(withEmail: mailText.text!, password: passwordText.text!) { (auth, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
                else{
                    
                    let userDictionary = ["email" : self.mailText.text!, "userName" : self.userNameText.text!] as [String : Any]
                    
                    let fireStore = Firestore.firestore()
                    fireStore.collection("UserInfo").addDocument(data: userDictionary) { (error) in
                        if error != nil{
                            //
                        }
                    }
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
            
        }
        else{
            self.makeAlert(titleInput: "Error", messageInput: "Boşlukları Doldurunuz")
        }
        
    }
    
    
    
    func makeAlert(titleInput : String, messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

