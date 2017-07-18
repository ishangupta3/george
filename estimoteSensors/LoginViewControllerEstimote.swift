//
//  LoginViewControllerEstimote.swift
//  estimoteSensors
//
//  Created by ishgupta on 7/13/17.
//  Copyright © 2017 ishgupta. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewControllerEstimote: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
     var handle: AuthStateDidChangeListenerHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    
    
        override func viewWillAppear(_ animated: Bool) {
    
            handle = Auth.auth().addStateDidChangeListener { (auth, user) in
    
                if Auth.auth().currentUser != nil {
    
                    self.performSegue(withIdentifier:"goToHome", sender: self )
    
                }
    
            }
    
    
        }
    
    
        override func viewWillDisappear(_ animated: Bool) {
            Auth.auth().removeStateDidChangeListener(handle!)
            
        }
     
     
     

    
    //////
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        
    
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error != nil {
                    
                    let alert = UIAlertController(title: "Alert", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    print((message: (error?.localizedDescription)!))
                    
                    
                    
                    
                } else {
                    
                    
                    self.performSegue(withIdentifier:"goToHome", sender: self )
                    print("User Created")
                }
                
                
                // take to the home screen
            }
            
        
        
        
        
        
    }
    
    
    
    
    
    
}
