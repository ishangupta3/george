//
//  ViewController.swift
//  estimoteSensors
//
//  Created by ishgupta on 6/23/17.
//  Copyright © 2017 ishgupta. All rights reserved.
//

import UIKit

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
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//      
//        self.triggerManager.delegate = self
//        let rule1 = ESTOrientationRule.orientationEquals(.horizontalUpsideDown, for: .dog)
//        let rule2 = ESTMotionRule.motionStateEquals(true, forNearableIdentifier:"733a6e0e829a8bed")
//        
//        let trigger = ESTTrigger(rules: [rule2], identifier: "goodboy")
//        self.triggerManager.startMonitoring(for: trigger)
        
        
        
        
       self.nearableManager.startMonitoring(forIdentifier: "733a6e0e829a8bed")
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
        
        
        self.nearableManager.stopRanging(forIdentifier: nearable.identifier)
    }
    
    
  
    
    func nearableManager(_ manager: ESTNearableManager, didEnterIdentifierRegion identifier: String)
    {
        
//        if identifier == "733a6e0e829a8bed" {
//        
//           print(identifier)
//          
//        
//          print("ENTERED REGION")
//            
//            
//            let x: String = getDateTime()
//            
//            print(x)
//            
//            
//             print("******************")
//            
//            
//            
//        }
        
        
  
        
        print(identifier)
        nearableID.text = identifier
        
        self.nearableManager.startRanging(forIdentifier: identifier)
        
    }
    
    
    
    
    
    
    
    
    
    
    func nearableManager(_ manager: ESTNearableManager, didExitIdentifierRegion identifier: String) {
        
        
        
        print("EXITED REGION")
        print(identifier)
        print("EXITED REGION")
        
        print(getDateTime())
        
        
        
        self.nearableManager.startMonitoring(forIdentifier: "733a6e0e829a8bed")
        self.nearableManager.startMonitoring(forIdentifier: "2d54e81304d984af")

        
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

