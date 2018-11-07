//
//  LoginViewController.swift
//  Cst495-Project
//
//  Created by Brandon Shimizu on 10/23/18.
//  Copyright © 2018 rbradley. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    var currentUser = PFUser.current()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
    }
    
    
    @IBAction func onSignup(_ sender: Any) {
        let newUser = PFUser()

        newUser.username = usernameField.text
        newUser.password = passwordField.text

        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                if error._code == 202{
                    print("Username is already taken")
                }
                else{
                    print(error.localizedDescription)
                }
            }
            else {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                print("User Registered successfully")
                // manually segue to logged in view
            }
        }
    }
    
    
    @IBAction func onLogin(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) in
            if user != nil {
                print("you're logged in!")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    
    
}
