//
//  DatabaseParent.swift
//  estimoteSensors
//
//  Created by ishgupta on 9/15/17.
//  Copyright © 2017 ishgupta. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth


struct  DatabaseParent  {
    
        let userID: String
        let timeStamp: Int
        let location: String
        let signalStrength: Int
        
        
    
        
        
//    
//        init(userID: String, timeStamp: Int, location: String, signalStrength: Int) {
//            self.userID = userID
//            self.timeStamp = timeStamp
//            self.location = location
//            self.signalStrength = signalStrength
//        }
    
        func sendToDatabse(userID: String, timeStamp: Int, location: String, signalStrength: Int) {
            
          
            let data: NSDictionary
            
            data = [
                
                "userID" : userID,
                "RSSI"   : signalStrength,
                "timestamp": timeStamp,
                "location" : location
                
            ]
            
            
            let ref = Database.database().reference().child("Everything").childByAutoId()
            ref.setValue(data)

            
            
        }
    
    
    
    }
