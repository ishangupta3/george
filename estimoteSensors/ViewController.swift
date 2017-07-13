//
//  ViewController.swift
//  estimoteSensors
//
//  Created by ishgupta on 6/23/17.
//  Copyright © 2017 ishgupta. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, ESTNearableManagerDelegate /* ESTTriggerManagerDelegate  */ {
    
    
    
    
   //   let triggerManager = ESTTriggerManager()
    
    
    var nearableManager: ESTNearableManager
    var nearable: ESTNearable
    
    var broadcastingValue: ESTSettingNearableBroadcastingScheme
    
   
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
        
        
       self.nearableManager.startMonitoring(forIdentifier: "0ab1d9bd539d61a0")
       self.nearableManager.startMonitoring(forIdentifier: "2d54e81304d984af")
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
        
      

        print(nearableInformation[nearable.identifier]!["location"]!)
        
        self.nearableManager.stopRanging(forIdentifier: nearable.identifier)
       // self.nearableManager.startMonitoring(forIdentifier: nearable.identifier)
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
        
        
        
     self.nearableManager.startMonitoring(forIdentifier: identifier)
        
        
        
        
        
       
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

