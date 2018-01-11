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

class ViewController: RangeViewController, ESTNearableManagerDelegate, CBPeripheralManagerDelegate,  UITableViewDataSource /* ESTTriggerManagerDelegate  */ {
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
                                     "Layers": 0,
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
                                     "PalletesSalad" : 0,
                                     "TestingRoom" : 0
    ]
    
    
    var sensorInfoMissing: [String: Int] = ["PalletesSushi": 0,
                                            "Layers": 0,
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
                                            "PalletesSalad" : 0,
                                            "TestingRoom" : 0
    ]
    
    
    
    var sensorInfoTime: [String: Int] = ["PalletesSushi": 0,
                                         "Layers": 0,
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
                                         "PalletesSalad" : 0,
                                         "TestingRoom" : 0
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
        
//        do {
//            try Auth.auth().signOut()
//            print("signedoout")
//        } catch (let error) {
//            print((error as NSError).code)
//        }
        
        debugModeCheck = true
    }
    
    
    
    func initNotificationSetupCheck() {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("permission chilling")
            } else {
                
                print("No permisison given")
            }
        }
        
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
//        { (success, error) in
//            if success {
//                print("Permission Granted")
//            } else {
//                print("There was a problem!")
//            }
//        }
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
    
    
    
    @objc func populate() {
        
        //  nearablesRangedArray.append("hi")
        tableView.reloadData()
        refresher.endRefreshing()
        
        
    }
    
    
 
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Auth.auth().currentUser?.email, "!!!!!!!AUTH!!!!!!")
        let date = DateComponents()
       
        print(date.day, "This is the current weekday")
        runTimer()
        //
        //        self.triggerManager.delegate = self
        //        let rule1 = ESTOrientationRule.orientationEquals(.horizontalUpsideDown, for: .dog)
        //        let rule2 = ESTMotionRule.motionStateEquals(true, forNearableIdentifier:"733a6e0e829a8bed")
        //
        //        let trigger = ESTTrigger(rules: [rule2], identifier: "goodboy")
        //        self.triggerManager.startMonitoring(for: trigger)
        
        initNotificationSetupCheck()
    
        Database.database().isPersistenceEnabled = false
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
        self.nearableManager.startMonitoring(forIdentifier: "bf3a127b7d4fdcd3")   // Layers
        self.nearableManager.startMonitoring(forIdentifier: "b525098a0dce7b05")   // BackgroundTestPurpleFridge
        
        // insert other nearable to see if the code will work
        
        
        //  self.nearableManager.startMonitoring(forIdentifier: "23e1f0c6b8996e1d")  // TestingRoom
        
        //  self.nearableManager.startMonitoring(forIdentifier: "6788c858ccfcd163")   // LayersEntranceExit / kitchen
        
        
        
        
        
        
        
        
        
        //        self.nearableManager.startRanging(forIdentifier: "6788c858ccfcd163")    // kitchen
        
        
        
        //  *****************************************************   - Debugging Code- VIEW DID LOAD
        
        
        //***********************************************
        
        
        
//        let content = UNMutableNotificationContent()
//        content.title = "Please swipe on Notification to keep app in background"
//        content.body = "**This helps us to help you**"
//        content.sound = UNNotificationSound.default()
//
//
//
//
//        // let date 2 = Date.
//        var date = DateComponents()
//        date.hour =  10
//        date.minute = 45
//
//
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
//        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
//   UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
//        let center = UNUserNotificationCenter.current()
//        center.add(request, withCompletionHandler: nil)
//
        
//        let notification = UNMutableNotificationContent()
//        notification.title =  "test:"
//        notification.subtitle = "this works"
//        notification.body =  "this works"
//        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false )
//        let requestTest = UNNotificationRequest(identifier: "notification1", content: notification, trigger: trigger)
//        UNUserNotificationCenter.current().add(requestTest, withCompletionHandler: nil)
//
//
//
        
        
        
        
        
        
        
        
       runNotification()
        getData()
        
    }
    
    
    
    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateTimer() {
        
        nearableLocation.backgroundColor = UIColor.green
        nearableSignal.backgroundColor = UIColor.green
        
        
        
    }
    
    
    func runNotification() {
        
        var date2 = DateComponents()
        let content = UNMutableNotificationContent()
        content.title = "Almoste time for lunch"
        content.body = ""
        
        content.sound = UNNotificationSound.default()
        
        // let date 2 = Date.
        
        date2.hour =  11
        date2.minute =  15
        
        
        
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date2, repeats: true)
        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    func nearableManager(_ manager: ESTNearableManager, didRangeNearable nearable: ESTNearable) {
        
        
        
        
        
        print("found nearable", nearable.identifier)
        print(nearable.rssi)
        
        let nearableSignalString = String(nearable.rssi)
        let nearableName = String(nearableInformation[nearable.identifier]!["location"]!)
        
        // print("This nearable has been ranged: ", nearable.identifier, nearable.rssi)
        var message = String(describing: ("This nearable has been ranged: ", nearable.identifier, nearable.rssi))
        
        
        
        let nearableNameTEST = String(nearableInformation[nearable.identifier]!["location"]!)
        
        
        // SEND to DB (Everything)
        
        if nearable.rssi != 127  {
            let everything: NSDictionary
            everything = [
                "userID" : self.user!.uid,
                "RSSI": (nearable.rssi),
                "timestamp": Int(Date().timeIntervalSince1970),
                "location" : nearableInformation[nearable.identifier]!["location"]!
            ]
          let ref = Database.database().reference().child("Everything").childByAutoId()
         //   let ref = Database.database().reference().child("TESTING").childByAutoId()
            ref.setValue(everything)
        }
        
        // SEND to DB (Everything)
        
    
        debugSignalStrengthArray.removeAll()
        debugRangedSensorTitle.removeAll()
        
        
        //    *********************************    Start of the bug fixing
        
        /*
         
         if nearable.rssi != 127 {
         
         for (location, lastSeenSensorTime) in sensorInfoTime {
         
         if location == nearableName! {
         
         if lastSeenSensorTime == 0 ||  Int(Date().timeIntervalSince1970) - lastSeenSensorTime <= 5 {
         
         sensorInfo.updateValue(0, forKey: nearableName!)
         
         // send to DB because it is the first time app has come across the sensor
         
         let cleaned: NSDictionary
         cleaned = [
         
         
         "userID" : user!.uid,
         "RSSI": (nearable.rssi),
         "timestamp": Int(Date().timeIntervalSince1970),
         "location" : nearableInformation[nearable.identifier]!["location"]!
         
         ]
         
         //  print(nearable.rssi)
         let ref = Database.database().reference().child("Everything").childByAutoId()
         ref.setValue(cleaned)
         
         //                        DatabaseParent.init(userID: user!.uid, timeStamp: Int(Date().timeIntervalSince1970) , location: nearableInformation[nearable.identifier]!["location"]!, signalStrength: nearable.rssi)
         
         
         
         } else {
         
         
         //  print(Int(Date().timeIntervalSince1970) - lastSeenSensorTime, "More then 5 Seconds", nearable.rssi)
         
         
         // send second value onwards to the database ----- >
         
         // everything under this is essentially useless -- > might want to remove
         
         for (location, timeIncrementer) in sensorInfo {
         
         //  print(Int(Date().timeIntervalSince1970) - lastSeenSensorTime)
         
         if location == nearableName! {
         
         var x = timeIncrementer
         x += 1
         sensorInfo.updateValue(x, forKey: nearableName!)
         // print("getting rid of this signal Strength", nearable.rssi)
         if x >= 3  { // does using "x" work
         
         // SEND to DB || this is removing the first bad entry in a new list of signal strengths
         
         
         }
         
         
         }
         }
         
         
         
         }
         
         //   print(Int(Date().timeIntervalSince1970) - lastSeenSensorTime)
         
         }
         
         }
         
         
         }
         
         sensorInfoTime.updateValue(Int(Date().timeIntervalSince1970), forKey: nearableName!) // getting the last time signal of the last sensor
         
         
         
         
         
         
         
         //    *********************************    END of the bug fixing
         
         if nearable.rssi != 127 {
         
         
         for (location, timeIncrementer) in sensorInfo {
         
         if location == nearableName! {
         
         sensorInfoMissing.updateValue(0, forKey: nearableName!) // nearable not missing anymore (found)
         
         
         
         
         var x = timeIncrementer
         x += 1
         sensorInfo.updateValue(x, forKey: nearableName!)
         
         if x >= 2  { // does using "x" work
         
         // SEND to DB || this is removing the first bad entry in a new list of signal strengths
         
         let cleaned: NSDictionary
         cleaned = [
         
         
         "userID" : user!.uid,
         "RSSI": (nearable.rssi),
         "timestamp": Int(Date().timeIntervalSince1970),
         "location" : nearableInformation[nearable.identifier]!["location"]!
         
         ]
         
         
         let ref = Database.database().reference().child("Cleaned").childByAutoId()
         ref.setValue(cleaned)
         
         
         }
         
         
         }
         
         
         
         
         for (location, timeIncrementerMissing) in sensorInfoMissing {
         
         if location != nearableName! {
         
         var y = timeIncrementerMissing
         y += 1
         sensorInfoMissing.updateValue(y, forKey: nearableName!)
         
         if y >= 5 {
         
         sensorInfo.updateValue(0, forKey: nearableName!)
         
         }
         
         }
         
         
         
         }
         
         
         }
         
         
         }
         
         
         
         */
        
        
        
        //   ****
        
        
        /*      Average Loop Algo
         
         if  nearable.rssi != 127 {
         
         
         for (location, timeIncrementer)  in sensorInfo {
         
         if location == nearableName! {
         
         
         var x = timeIncrementer
         x += 1
         sensorInfo.updateValue(x, forKey: nearableName!)
         
         
         for (locationAverage, sensorStrengthAverage) in sensorInfoAverage {
         
         if locationAverage == nearableName! { // checking for signal average dict
         
         var y = sensorStrengthAverage
         y += nearable.rssi
         sensorInfoAverage.updateValue(y, forKey: nearableName!)   // updating the average of the sums of the nearable signals
         
         if   sendDataCheck(timeCounter: timeIncrementer) == true    {
         
         sensorInfo.updateValue(0, forKey: nearableName!)
         
         if sendAverageCheck(averageCounter: sensorStrengthAverage) == true  {                                     // do if else and the else will update the average value to 0...
         
         
         // DO THE AVERAGE HER OF THE INCREMENTED DATA THEN CREATE ANOTHER IF
         
         
         
         let dateData: NSDictionary
         dateData = ["userID" : user!.uid,
         "RSSI": nearable.rssi, // check if it works with x cross check it with physical number
         "timestamp": ServerValue.timestamp(),
         "location" : nearableInformation[nearable.identifier]!["location"]!]
         
         
         
         
         //  let ref = Database.database().reference().childByAutoId()
         let ref = Database.database().reference().child("strictFiltered").childByAutoId()
         //   ref.setValue(dateData)
         
         // self.nearableManager.startMonitoring(forIdentifier: nearable.identifier)
         
         sensorInfoAverage.updateValue(0, forKey: nearableName!) // refresh the value to 0 for sensor
         
         
         
         }   else {  // inner if loop checking the average to be under 75
         
         sensorInfoAverage.updateValue(0, forKey: nearableName!)
         }
         } // checking the counter value to be 5 readings
         
         }
         
         }  // inner for loop for average
         
         }
         
         
         }
         
         
         }
         
         
         
         */
        
        
        //***
        
        //   print(sensorInfo)
        
        
        
        
        for  (location, timeIncrementer) in sensorInfo {
            
            
            debugSignalStrengthArray.append(timeIncrementer)
            debugRangedSensorTitle.append(location)
            
            
            
            
            
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
        
        
        self.nearableManager.startMonitoring(forIdentifier: nearable.identifier)    // uncomment     after testing
        
        
        self.nearableManager.startRanging(forIdentifier: nearable.identifier)
        
        
        
        
    }
    
    
    
    
    
    
    func nearableManager(_ manager: ESTNearableManager, didEnterIdentifierRegion identifier: String)
    {
        
        
       // notifStruct(title: "Background works", subtitle: "Background Works", body: "This is chill")
        
        
        nearableLocation.backgroundColor = UIColor.blue
        nearableSignal.backgroundColor = UIColor.blue
        print("You have entered the REGION******* HELLO")
        self.view.backgroundColor = UIColor.white
        nearableID.textColor = UIColor.black
        // print("*******************************************************************************")
        print("You have entered the REGION******* HELLO")
        print("**************************MONITORED**********************")
        
        //  print(nearableInformation[identifier]!["location"]!, "MONITORED VALUE")
        
        //    print("*************************MONITORED**************************")
        
        
        self.nearableManager.startRanging(forIdentifier: identifier)
        self.nearableManager.startRanging(forIdentifier: identifier)
        self.nearableManager.startRanging(forIdentifier: identifier)
        //  self.nearableManager.startMonitoring(forIdentifier: identifier) // check if this has anything to do with more efficient reporting
        
        let nearableName = String(nearableInformation[identifier]!["location"]!)
        
        
        let dateData: NSDictionary
        dateData = [
            "timestamp": ServerValue.timestamp(),
            "userID" : user!.uid,
            "location" : nearableInformation[identifier]!["location"]!]
        
        
        let ref = Database.database().reference().child("RegionEntered").childByAutoId()
        //  ref.setValue(dateData)
        
        // send local noticiation
        
        
        
        /*
         
         
         
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
         
         
         
         
         
         
         
         
         // END of did ENTER REGION
         
         
         
         */
        
    }
    
    
    
    
    
    
    
    
    
    
    func nearableManager(_ manager: ESTNearableManager, didExitIdentifierRegion identifier: String) {
        
        print("you left the region ******** BYE BYE ")
        
        // print(identifier)
        
     //   notifStruct(title: "This is an exit", subtitle: "chill", body: "chill")
        
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
        self.nearableManager.startMonitoring(forIdentifier: identifier)
        
        
    }
    
    
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        
//        let content = UNMutableNotificationContent()
//        content.title = "Please swipe on Notification to keep app in background"
//        content.body = "**This helps us to help you**"
//        content.sound = UNNotificationSound.default()
//        
//        
//        
//        
//        // let date 2 = Date.
//        var date = DateComponents()
//        date.hour =  10
//        date.minute = 56
//        
//        
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
//        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//        
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
            
            
//
//            let content = UNMutableNotificationContent()
//            content.title = "Don't forget to turn ON bluetooth"
//            content.body = "Thank you"
//            content.sound = UNNotificationSound.default()
//
//
//            let date = Date(timeIntervalSinceNow: 60)
//            let date1 = Date(timeIntervalSince1970:  1502710200)
//            // let date 2 = Date.
//            let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second], from: date1)
//            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
//            let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            
            
           
        }
    }
    
    
    func getData() {
        
        let userID = Auth.auth().currentUser?.uid
    
        var ref: DatabaseReference! = Database.database().reference()
        ref.child("XYSENSORS").observe(.value) { snapshot in
            
            for child in snapshot.children {
            //   print(child)
             //  print(snapshot.value(forKey: "location"))
            }
        }
        
         ref.child("XYSENSORS").observeSingleEvent(of: .value, with: { (snapshot) in
        
            for child in snapshot.children{
                
                let snap = child as! DataSnapshot
                let dict = snap.value as? NSDictionary
                let location = dict!["userID"]
                print(location , "this is the userID")
                
            }
            
            
        })
    
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

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

