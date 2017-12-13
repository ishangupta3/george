//
//  PasswordReset.swift
//  estimoteSensors
//
//  Created by ishgupta on 12/8/17.
//  Copyright © 2017 ishgupta. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class PasswordReset: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func passwordReset(_ sender: Any) {
        
        
        
        Auth.auth().sendPasswordReset(withEmail: emailField.text!) { (error) in
          
            if self.emailField.text == "" {
                
                let alert = UIAlertController(title: "Alert", message: "Please input Email", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
            
            if error != nil {
                
                print(error)
                
                let alert = UIAlertController(title: "Email Not Found", message: "Try another email", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                let alert = UIAlertController(title: "Successful", message: "Password Reset Email sent to:  \(self.emailField.text)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
               
            }
            
            
            
        }
    }
    
}
