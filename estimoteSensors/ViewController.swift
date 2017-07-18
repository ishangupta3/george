//
//  ViewController.swift
//  estimoteSensors
//
//  Created by ishgupta on 6/23/17.
//  Copyright © 2017 ishgupta. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseDatabase
import FirebaseAuth
import Firebase

class ViewController: UIViewController, ESTNearableManagerDelegate /* ESTTriggerManagerDelegate  */ {
    
    
    
    
   //   let triggerManager = ESTTriggerManager()
    
    
    var nearableManager: ESTNearableManager
    var nearable: ESTNearable
    
    var broadcastingValue: ESTSettingNearableBroadcastingScheme
    
    
    var ref: DatabaseReference!
    
    
    
   var user = Auth.auth().currentUser
    
    var email = Auth.auth().currentUser?.email
    
    
   
    @IBOutlet weak var nearableID: UILabel!
    
    
    required init?(coder aDecoder: NSCoder)
    {
        self.nearable = ESTNearable()
        self.nearableManager = ESTNearableManager()
        self.broadcastingValue = ESTSettingNearableBroadcastingScheme()

        
        super.init(coder: aDecoder)
        
        self.nearableManager.delegate = self
    }
    
    
    
    func initNotificationSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
        { (success, error) in
            if success {
                print("Permission Granted")
            } else {
                print("There was a problem!")
            }
        }
    }
   
    
  
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//      
//        self.triggerManager.delegate = self
//        let rule1 = ESTOrientationRule.orientationEquals(.horizontalUpsideDown, for: .dog)
//        let rule2 = ESTMotionRule.motionStateEquals(true, forNearableIdentifier:"733a6e0e829a8bed")
//        
//        let trigger = ESTTrigger(rules: [rule2], identifier: "goodboy")
//        self.triggerManager.startMonitoring(for: trigger)
        
        initNotificationSetupCheck()
        Database.database().isPersistenceEnabled = true

        
        
       self.nearableManager.startMonitoring(forIdentifier: "0ab1d9bd539d61a0")
     //  self.nearableManager.startMonitoring(forIdentifier: "2d54e81304d984af")  // UNCOMMENT AFTEr TESTIGN
      //  self.nearableManager.startRanging(forIdentifier: "733a6e0e829a8bed")
      //   self.nearableManager.startRanging(forIdentifier: "2d54e81304d984af")

       
        
        
     
        

        
        
            }
    
    
//    func getNearableInformation(identifier: String!) -> ESTNearable {
//        
//        let nearableInfo = nearable[identifier] as ESTNearable
//        
//        return nearableInfo
//        
//    }
    
    
    
        
    func nearableManager(_ manager: ESTNearableManager, didRangeNearable nearable: ESTNearable) {
     
        
        print("This nearable has been ranged: ", nearable.identifier, nearable.rssi)
        
        
        nearableID.text = "This nearable has been ranged: "; nearable.identifier; nearable.rssi
        
        print(getDateTime())
        print(user!.uid)
        
        let dateData: NSDictionary
        
        let ref = Database.database().reference().child("Enter").child((user?.uid)!)
        dateData = ["RSSI": nearable.rssi, "timestamp": ServerValue.timestamp(), "location" : nearableInformation[nearable.identifier]!["location"]]
        let key = ref.childByAutoId().key
        ref.child(key).setValue(dateData)
        
        self.nearableManager.stopRanging(forIdentifier: nearable.identifier)
        
        
      //  var locationData: NSDictionary
        
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
    }
    
    
  
    
    func nearableManager(_ manager: ESTNearableManager, didEnterIdentifierRegion identifier: String)
    {
        
       
        
        
  
        
        print(identifier)
        nearableID.text = "You have entered the Region"
        
        self.nearableManager.startRanging(forIdentifier: identifier)
        
    }
    
    
    
    
    
    
    
    
    
    
    func nearableManager(_ manager: ESTNearableManager, didExitIdentifierRegion identifier: String) {
        
        
        
        print("EXITED REGION", getDateTime(), nearable.identifier)
      
        
        
        nearableID.text = "You have left the region"
        
        /*
        let refExit = Database.database().reference().child((user?.uid)!).child("dateExited")
        //  ref = Database.database().reference().child("users").child(email!)
        let dateExitData = ["dateExit": getDateTime()]
        let key = refExit.childByAutoId().key
        refExit.child(key).setValue(dateExitData)
        
        */
        
    
        
        
        
        
        
       
        let notification = UNMutableNotificationContent()
        notification.title = "you have left the region"
        notification.subtitle = "bye bye"
        notification.body = "have fun"
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        

        
    }
    
 

    
    
    
    func getReadableTimestamp(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        dateFormatter.dateFormat = format
        
        let datetime = dateFormatter.string(from: Date())
        
        return datetime
    }
    
    
    
    func getDateTime() -> String{
        let datetime = getReadableTimestamp("MM/dd/yyyy HH:mm:ss")
        return "[\(datetime)]"
    }
    
    
    
//    
//    func triggerManager(_ manager: ESTTriggerManager,triggerChangedState trigger: ESTTrigger) {
//        if (trigger.identifier == "goodboy") {
//            print("Hello, digital world! The physical world has spoken.")
//            print("Identifier has been foubd", trigger.identifier)
//        } else {
//            print("Goodnight. <spoken in the voice of a turret from Portal>")
//        }
//    }

   
}

