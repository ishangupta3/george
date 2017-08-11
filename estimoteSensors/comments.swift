//
//  comments.swift
//  estimoteSensors
//
//  Created by ishgupta on 8/10/17.
//  Copyright © 2017 ishgupta. All rights reserved.
//

import Foundation



/*
 
 averageSignalStrength.append(nearable.rssi)
 let signalCounts = averageSignalStrength.count
 
 if signalCounts == 5 {
 
 var total: Int = 0
 
 
 for element in averageSignalStrength {             ****** FINDING AVERAGES IN DID RANGE*****
 
 
 
 total = total + (element * -1)
 
 
 }
 
 print(total / signalCounts)
 averageSignalStrength.removeAll()
 
 
 }
 
 */





//***************************


/*
 
 let ref = Database.database().reference().child(user!.uid) //  .child(timeDict) // .child("Enter")
 
 
 
 
 dateData = ["RSSI": nearable.rssi,
 "timestamp": ServerValue.timestamp(),
 "location" : nearableInformation[nearable.identifier]!["location"]!]
 
 
 
 let key = ref.childByAutoId().key
 let keys =  String(describing: Int(round(Date().timeIntervalSince1970)))
 ref.child(keys).setValue(dateData)
 
 
 */







//  created nested dictionaries
// corner case of signal strength being 127





/*
 
 
 let ref = Database.database().reference().child((user?.uid)!).child("dateEntered")
 //  ref = Database.database().reference().child("users").child(email!)
 let dateData = ["date": getDateTime()]
 let key = ref.childByAutoId().key
 ref.child(key).setValue(dateData)
 
 
 let refRSSI = Database.database().reference().child((user?.uid)!).child("dateEntered").child("RSSI")
 //  ref = Database.database().reference().child("users").child(email!)
 let rssiData = ["RSSI": nearable.rssi]
 let keyRSSI = ref.childByAutoId().key
 refRSSI.child(keyRSSI).setValue(rssiData)
 
 
 
 
 let  refLocation = Database.database().reference().child((user?.uid)!).child("location")
 let locationData = ["location": nearableInformation[nearable.identifier]!["location"]!]
 let locationKey = refLocation.childByAutoId().key
 refLocation.child(locationKey).setValue(locationData)
 
 print(nearableInformation[nearable.identifier]!["location"]!)
 
 self.nearableManager.stopRanging(forIdentifier: nearable.identifier)
 // self.nearableManager.stopMonitoring(forIdentifier: nearable.identifier)
 // self.nearableManager.startMonitoring(forIdentifier: nearable.identifier)
 
 
 
 */

/*




if nearable.rssi < -75  || nearable.rssi == 127 {
    
    
    
    sensorInfo.updateValue(0, forKey: nearableName!)
    
    
} else if nearable.rssi >=  -75 {  // NEED TO GET RID OF THE 75
    
    
    
    
    for (location, timeIncrementer)  in sensorInfo {
        
        if location == nearableName! {
            
            
            var x = timeIncrementer                                                         ***** ORIGNAL ALGO fOR filtering sensors
            x += 1
            sensorInfo.updateValue(x, forKey: nearableName!)
            
            if   sendDataCheck(timeCounter: timeIncrementer) == true    {
                
                
                // DO THE AVERAGE HER OF THE INCREMENTED DATA THEN CREATE ANOTHER IF
                
                
                
                let dateData: NSDictionary
                dateData = ["userID" : user!.uid,
                            "RSSI": nearable.rssi,
                            "timestamp": ServerValue.timestamp(),
                            "location" : nearableInformation[nearable.identifier]!["location"]!]
                
                let time = getDateTime()
                
                //***************************
                let ref = Database.database().reference().childByAutoId()
                ref.setValue(dateData)
                
                
                sensorInfo.updateValue(0, forKey: nearableName!)
                
                
            }
            
            
            
        }
        
        
    }
    
    
}
    
else {
    
    
    print()
    
}

 
 */
        */
