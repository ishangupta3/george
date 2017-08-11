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
    var ref2: DatabaseReference!
    
    @IBOutlet weak var nearableLocation: UILabel!
    
    @IBOutlet weak var nearableSignal: UILabel!
    
   var user = Auth.auth().currentUser
    
    var email = Auth.auth().currentUser?.email
    
    //************************************************ **************************** ************* DEBUGGING CODE
   
     var  debugSignalStrengthArray: [Int] = []
    var debugRangedSensorTitle: [String] = []
    
    @IBOutlet weak var nearableLocation3: UILabel!
    
    
    
    var sensorInfo: [String: Int] = ["PalletesSushi": 0,
                                    "Elevator": 0,
                                    "PalletesDishwasher" : 0,
                                    "PalletesEntranceExit" : 0,
                                    "TemplatesAsia" : 0,
                                    "TemplatesIndia" : 0,
                                    "TemplatesBurger" : 0,
                                    "TemplatesHomeStyle" : 0,
                                    "TemplatesEntrance" : 0,
                                    "TemplatesDishwasher" : 0,
                                    "PalletesGreekMexican" : 0,
                                    "PalletesPizza" : 0,
                                    "PalletesSalad" : 0
                                     ]
    
    
    var meanSensorSignal: [String : [Int]]  = [:]
    
    
    var timeIncrementers: Int = 0
    
    
    
  
    var averageSignalStrength: Array = [0]
    
    
    
    
    
    
    
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
    
    
    var debugModeCheck: Bool = false
    @IBAction func debugMode(_ sender: Any) {
        
        
        
        debugModeCheck = true
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
        
     
        
       self.nearableManager.startMonitoring(forIdentifier: "0ab1d9bd539d61a0")  // TemplatesEntrance    // installed
       self.nearableManager.startMonitoring(forIdentifier: "2d54e81304d984af")  // TemplatesDishwasher  // installed
       self.nearableManager.startMonitoring(forIdentifier: "21e91bbf6cf59076")  //Templates Asia        // installed
        self.nearableManager.startMonitoring(forIdentifier: "9713290c1e7c1016")  // TemplatesIndia      // installed
       self.nearableManager.startMonitoring(forIdentifier: "86032bc0d660db2b")   //Templateshomestyle   // installed
        self.nearableManager.startMonitoring(forIdentifier: "a18c67f6cbf70ee6")   // TemplatesBurger    // installed
         self.nearableManager.startMonitoring(forIdentifier: "9d1fcf092f7f7c5e")   // PalletesEntrance
         self.nearableManager.startMonitoring(forIdentifier: "726477ebba894da0")   // PalletesSalad
        self.nearableManager.startMonitoring(forIdentifier: "7e87ff288c396700")   // PalletesDishwasher
         self.nearableManager.startMonitoring(forIdentifier: "2e59eb1b7809cd54")   // PalletesSushi
        
        self.nearableManager.startMonitoring(forIdentifier: "b5a3395f8bb86c97")    // Palletes Pizza
        
         self.nearableManager.startMonitoring(forIdentifier: "f348b513c73f8900")   // Palletes Greek Mexican
        
        
       // self.nearableManager.startMonitoring(forIdentifier: "bf3a127b7d4fdcd3")   // Layers
       
      //  self.nearableManager.startMonitoring(forIdentifier: "6788c858ccfcd163")   // LayersEntranceExit / kitchen
        
     
     
  
        
 
        
        

//        self.nearableManager.startRanging(forIdentifier: "6788c858ccfcd163")    // kitchen


        
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
       
        
     
       

        //****************************************************************************** -> Debugging Code
         let nearableSignalString = String(nearable.rssi)
        let nearableName = String(nearableInformation[nearable.identifier]!["location"]!)
       
       
        
        

    
       
     
        
         debugSignalStrengthArray.removeAll()
         debugRangedSensorTitle.removeAll()
        
        
        
        
        averageSignalStrength.append(nearable.rssi)
        let signalCounts = averageSignalStrength.count
        
        if signalCounts == 5 {
            
            var total: Int = 0
          
            
            for element in averageSignalStrength {
                
              
                
                total = total + (element * -1)
                
                
            }
            
           print(total / signalCounts)
            averageSignalStrength.removeAll()
            
            
        }
        
        
      
        
        /*
 
            Logic  : IF the signal Strength is under "70" then increment the counter for that SPECIFC sensor title "Value" in the DICT
         
                have a boolean function which checks if the value of the dict passes a certain number thus saying true or false
 
        
        
        if debugRangedSensorTitle.contains(nearableName!) {
            
            print("alreadycontains element")
            sensorInfo.updateValue(nearable.rssi, forKey: nearableName!)
            
            
        } else {
            
            // debugRangedSensorTitle.append(nearableName!)
            sensorInfo.updateValue(nearable.rssi, forKey: nearableName!)
            
        }
 
 
            */
        
        // INCREASE SIGNAL CONSTRAINT with the proption of using time as the main key to obtaining data point
        // ask georgios about setting up 
   
        
    if nearable.rssi < -75  || nearable.rssi == 127 {
            

            
            sensorInfo.updateValue(0, forKey: nearableName!)
        
            
        } else if nearable.rssi >=  -75 {  // NEED TO GET RID OF THE 75
            
            
           // sensorInfo.updateValue(timeIncrementers, forKey: nearableName!)  // updating the vlaue in the dict everytime the signal is below "70"
            
            for (location, timeIncrementer)  in sensorInfo {
                
                if location == nearableName! {
                    
                    
                    var x = timeIncrementer
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
                        
                        // let ref = Database.database().reference().child(user!.uid) // .child("Enter")
                       
                        
                       
                      
                        
                        
                        
                       
                        
                        
                        
                      //  ref.child(keys).setValue(dateData)
                        
                        
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
                        
                    }

                    
                    
                }
                
                
            }
            
            
        }
        
        else {
        
        
           print()
        
        }
        
        
        
        
    //   print(sensorInfo)
        

        
        
        for  (location, timeIncrementer) in sensorInfo {
            
            
            debugSignalStrengthArray.append(timeIncrementer)
            debugRangedSensorTitle.append(location)
            
            
           
            
       //     print(location,timeIncrementer, "RANGING VALUE")
        //    print("******")
            
//
            
        }
        
        
       
       
     
        
        
        
        if debugModeCheck == true {
            
             self.view.backgroundColor = UIColor.red
            nearableLocation.text =  nearableInformation[nearable.identifier]!["location"]!
            nearableLocation.backgroundColor = UIColor.black
            nearableSignal.backgroundColor = UIColor.black
            nearableSignal.text = String(nearable.rssi)
            
        }
        
        
        
    
      
         //****************************************************************************** -> Debugging Code
        
       
        
     
       // print(user!.uid)
        
       
 
        
        
        
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
        
       
        
        print("*******************************************************************************")
        
         print("**************************MONITORED**********************")
        
        print(nearableInformation[identifier]!["location"]!, "MONITORED VALUE")

         print("*************************MONITORED**************************")
        
        
        self.nearableManager.startRanging(forIdentifier: identifier)
        
        
        /*
        
        
        let nearableName = String(nearableInformation[identifier]!["location"]!)
        
        if nearableName == "TemplatesDishwasher" || nearableName ==  "TemplatesEntrance" || nearableName == "PalletesEntranceExit" || nearableName == "PalletesDishwasher" {
            
            let dateData: NSDictionary
            dateData = ["userID" : user!.uid,
                        "RSSI": -75,
                        "timestamp": ServerValue.timestamp(),                                   // CHECK WHY app is DYING
                        "location" : nearableInformation[identifier]!["location"]!]
            
            
            let ref = Database.database().reference().childByAutoId()
            ref.setValue(dateData)

            // send local noticiation
        
            
        }
        
        
        
        if nearableLocation.text == "" {
        
         nearableLocation.text = nearableInformation[identifier]!["location"]!
            nearableLocation.backgroundColor = UIColor.blue
            nearableSignal.backgroundColor = UIColor.white
            nearableLocation3.backgroundColor = UIColor.white
            
            
        } else if nearableSignal.text == "" {
            
            nearableSignal.text = nearableInformation[identifier]!["location"]
             nearableSignal.backgroundColor = UIColor.red
            nearableLocation.backgroundColor = UIColor.white
            nearableLocation3.backgroundColor = UIColor.white
        } else {
            
            
            nearableLocation3.text = nearableInformation[identifier]!["location"]
            nearableLocation3.backgroundColor = UIColor.green
            nearableSignal.backgroundColor = UIColor.white
            nearableLocation.backgroundColor = UIColor.white
        }
        
    
 
 
 
        */
        
        
        // END of did ENTER REGION
        
    }
    
    
    
    
    
    
    
    
    
    
    func nearableManager(_ manager: ESTNearableManager, didExitIdentifierRegion identifier: String) {
        
        
        
        // print(identifier)
      
        
        
      //  nearableID.text = "You have left the region"
        
        /*
         
        let refExit = Database.database().reference().child((user?.uid)!).child("Exit")
        let dateExitData: NSDictionary = [ "timestamp": ServerValue.timestamp(),
                             "location" : nearableInformation[identifier]!["location"]!]
        let key = refExit.childByAutoId().key
        refExit.child(key).setValue(dateExitData)
        
     
        
    
        
        
      
        
       
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

