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
    
    @IBOutlet weak var whiteBox: UIImageView!
    
    @IBOutlet weak var logInBtn: UIButton!
    
    @IBOutlet weak var signupBtn: UIButton!
    
    var currentUser = PFUser.current()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        
        self.whiteBox.layer.cornerRadius = 15
        self.whiteBox.clipsToBounds = true
        self.logInBtn.layer.cornerRadius = 15
        self.logInBtn.clipsToBounds = true
        self.signupBtn.layer.cornerRadius = 15
        self.signupBtn.clipsToBounds = true
        whiteBox.layer.borderWidth = 2
        whiteBox.layer.borderColor = UIColor.white.cgColor
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
