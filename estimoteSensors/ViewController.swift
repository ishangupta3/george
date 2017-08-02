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
import CoreBluetooth

class ViewController: UIViewController, ESTNearableManagerDelegate, CBPeripheralManagerDelegate,  UITableViewDataSource/* ESTTriggerManagerDelegate  */ {
   // UITableViewDelegate,
    
    @IBOutlet weak var tableView: UITableView!
    
    
   //   let triggerManager = ESTTriggerManager()
    
    
    var nearableManager: ESTNearableManager
    var nearable: ESTNearable
    
    var broadcastingValue: ESTSettingNearableBroadcastingScheme
    
    var periManager: CBPeripheralManager!
    var ref: DatabaseReference!
    
    @IBOutlet weak var nearableLocation: UILabel!
    
    @IBOutlet weak var nearableSignal: UILabel!
    
   var user = Auth.auth().currentUser
    
    var email = Auth.auth().currentUser?.email
    
    //************************************************ **************************** ************* DEBUGGING CODE
   
     var  debugSignalStrengthArray: [Int] = []
    var debugRangedSensorTitle: [String] = []
    
    
    
    
    var sensorInfo: [String: Int] = [:]
    
    //****************************************************** **************************** ******* DEBUGGING CODE
    
   
    
    var refresher: UIRefreshControl!
    
    
   
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
   
    
    /// TABLE VIEW delegated methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  return nearablesRangedArray[0].count  //DONT FORGET TO UPDATE THIS VALUE
        return debugRangedSensorTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        /*  REMOVE AFTER TESTING
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            
        }
        
        cell!.textLabel?.text = nearablesRangedArray[indexPath.row]
        return cell!
 
        */  //  REMOVE AFTER TESTING
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DebugTableViewCell
       // cell.nearableSensorTitle.text = nearablesRangedArray[0][indexPath.row]
           cell.nearableSensorTitle.text = debugRangedSensorTitle[indexPath.row]
           cell.signalStrengthTitle.text = String(debugSignalStrengthArray[indexPath.row])
        return cell
        
        
        
        
          }
 
 
    
    func populate() {
        
      //  nearablesRangedArray.append("hi")
        tableView.reloadData()
        refresher.endRefreshing()
        
        
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
          periManager = CBPeripheralManager.init(delegate: self, queue: nil)
        
        
      //  tableView.dataSource = self REMOVE AFTER TESTING
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(ViewController.populate), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
     
        
     //  self.nearableManager.startMonitoring(forIdentifier: "0ab1d9bd539d61a0")  // TemplatesEntrance
     //  self.nearableManager.startMonitoring(forIdentifier: "2d54e81304d984af")  // TemplatesDishwasher
     //  self.nearableManager.startMonitoring(forIdentifier: "21e91bbf6cf59076")  //Templates Asia
     //   self.nearableManager.startMonitoring(forIdentifier: "9713290c1e7c1016")  // TemplatesIndia
     //  self.nearableManager.startMonitoring(forIdentifier: "86032bc0d660db2b")   //TemplatesCheckout
    //    self.nearableManager.startMonitoring(forIdentifier: "a18c67f6cbf70ee6")   // TemplatesBurger
     //    self.nearableManager.startMonitoring(forIdentifier: "9d1fcf092f7f7c5e")   // PalletesEntrance
     //    self.nearableManager.startMonitoring(forIdentifier: "726477ebba894da0")   // PalletesSalad
     //   self.nearableManager.startMonitoring(forIdentifier: "7e87ff288c396700")   // PalletesDishwasher
       //  self.nearableManager.startMonitoring(forIdentifier: "2e59eb1b7809cd54")   // PalletesSushi / ishans office
        
        
     //   self.nearableManager.startMonitoring(forIdentifier: "bf3a127b7d4fdcd3")   // PalletesSalad
       
     //   self.nearableManager.startMonitoring(forIdentifier: "6788c858ccfcd163")   // LayersEntranceExit / kitchen
        
      //  self.nearableManager.startMonitoring(forIdentifier: "f348b513c73f8900")   // LayersCashier/elevator
     
        //  self.nearableManager.startMonitoring(forIdentifier: "b5a3395f8bb86c97")   // Extra1 / Georgios office
        
 
        
        
          self.nearableManager.startRanging(forIdentifier: "2e59eb1b7809cd54") // ishans office
        self.nearableManager.startRanging(forIdentifier: "6788c858ccfcd163")    // kitchen
        self.nearableManager.startRanging(forIdentifier: "f348b513c73f8900")   //   Elevator
        self.nearableManager.startRanging(forIdentifier: "b5a3395f8bb86c97")    // Georgios Office
        
        
        //  *****************************************************   - Debugging Code- VIEW DID LOAD
        
       
  
        
        
        
        
        
        
        
        
        //***********************************************

        
            }
    
    
//    func getNearableInformation(identifier: String!) -> ESTNearable {
//        
//        let nearableInfo = nearable[identifier] as ESTNearable
//        
//        return nearableInfo
//
//    }
    
  
    
    func nearableManager(_ manager: ESTNearableManager, didRangeNearable nearable: ESTNearable) {
     
        
       // print("This nearable has been ranged: ", nearable.identifier, nearable.rssi)
         var message = String(describing: ("This nearable has been ranged: ", nearable.identifier, nearable.rssi))
       // print(message, "TESTING")
        
      
       

        //****************************************************************************** -> Debugging Code
         let nearableSignalString = String(nearable.rssi)
        let nearableName = String(nearableInformation[nearable.identifier]!["location"]!)
       
       
        
        

    
       
     
        
         debugSignalStrengthArray.removeAll()
         debugRangedSensorTitle.removeAll()
        
        
        if debugRangedSensorTitle.contains(nearableName!) {
            
            print("alreadycontains element")
            sensorInfo.updateValue(nearable.rssi, forKey: nearableName!)
            
            
        } else {
            
            // debugRangedSensorTitle.append(nearableName!)
            sensorInfo.updateValue(nearable.rssi, forKey: nearableName!)
            
        }
        

        
        
        for  (location, signalStrength) in sensorInfo {
            
            
            debugSignalStrengthArray.append(signalStrength)
            debugRangedSensorTitle.append(location)
            
            print(location,signalStrength)
            print("******")
            print(debugRangedSensorTitle,debugSignalStrengthArray)
            
        }
        
        
       
        
        
        
        
    
      
         //****************************************************************************** -> Debugging Code
        
       
        
        print(getDateTime())
        print(user!.uid)
        
        let dateData: NSDictionary
        
        let ref = Database.database().reference().child(user!.uid).child("Enter")
        dateData = ["RSSI": nearable.rssi,
                    "timestamp": ServerValue.timestamp(),
                    "location" : nearableInformation[nearable.identifier]!["location"]!]
        
        let key = ref.childByAutoId().key
        ref.child(key).setValue(dateData)
        
         nearableLocation.text =  nearableInformation[nearable.identifier]!["location"]!
         nearableSignal.text = String(nearable.rssi)
        
        
        
        
    //   self.nearableManager.stopRanging(forIdentifier: nearable.identifier)       // uncomment    after testing
    //   self.nearableManager.startMonitoring(forIdentifier: nearable.identifier)    // uncomment     after testing
        
        
   
        
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
        
       
        
        
        
         self.view.backgroundColor = UIColor.white
        nearableID.textColor = UIColor.black
        
        print(identifier)
        nearableID.text = "Ranging"
        
        self.nearableManager.startRanging(forIdentifier: identifier)
        
    }
    
    
    
    
    
    
    
    
    
    
    func nearableManager(_ manager: ESTNearableManager, didExitIdentifierRegion identifier: String) {
        
        
        
        print(identifier)
      
        
        
      //  nearableID.text = "You have left the region"
        
       
        let refExit = Database.database().reference().child((user?.uid)!).child("Exit")
        let dateExitData: NSDictionary = [ "timestamp": ServerValue.timestamp(),
                             "location" : nearableInformation[identifier]!["location"]!]
        let key = refExit.childByAutoId().key
        refExit.child(key).setValue(dateExitData)
        
     
        
    
        
        
        /*
        
        
       
        let notification = UNMutableNotificationContent()
        notification.title = "you have left the region"
        notification.subtitle = "bye bye"
        notification.body = "have fun"
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
 
 
 */
        
        self.nearableManager.startRanging(forIdentifier: identifier)
        

        
    }
    
 
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if peripheral.state == .poweredOn {
            print("powerd on")
        }
        if peripheral.state == .poweredOff {
            let alert = UIAlertController(title: "Bluetooth is turned Off", message: "To continue, plese turn bluetooth on!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            self.view.backgroundColor = UIColor.black
            nearableID.textColor = UIColor.white
            nearableID.text = "Bluetooth Turned Off"
            
            
        
            
        }
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

