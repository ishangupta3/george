//
//  FireBaseStruct.swift
//  estimoteSensors
//
//  Created by ishgupta on 10/13/17.
//  Copyright © 2017 ishgupta. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Firebase


    struct FirebaseStruct {

        var user: String
        var timestamp: Int
        var xCoordinate: Double
        var yCoordinate: Double
        var location: String
        // add location of the beacon
    
    // int it in the format of a dictionary 
       // send to firebase
        
        
        init(user: String, timestamp: Int, xCoordinate: Double, yCoordinate: Double, location: String) {
            
            self.user = user
            self.timestamp = timestamp
            self.xCoordinate = xCoordinate
            self.yCoordinate = yCoordinate
            self.location = location
            
            let XYData: NSDictionary
            
            XYData = [
                
                "userID" :  user,
                "X-Coordinate": xCoordinate,
                "Y-Coordinate": yCoordinate,
                "timestamp": timestamp,
                "location" : location
             //   "location" : nearableInformation[nearable.identifier]!["location"]!
              
            ]
            
            let ref = Database.database().reference().child("XYSENSORS").childByAutoId()
            ref.setValue(XYData)
            
        }
    }


    

//         func addToFirebase(user: String, timestamp: Int, xCoordinate: Double, yCoordinate: Double)
//         {
//            
//                let ref = Database.database().reference().child("XYSENSORS").childByAutoId()
//               ref.setValue(firebaseStruct(user: user, timestamp: timestamp, xCoordinate: xCoordinate, yCoordinate: yCoordinate))
//    
//         }



