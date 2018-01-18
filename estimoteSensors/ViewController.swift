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


class ViewController: RangeViewController,  ESTNearableManagerDelegate, CBPeripheralManagerDelegate,  UITableViewDataSource /* ESTTriggerManagerDelegate  */ {
    // UITableViewDelegate,
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //  var x = self.appDelegate.didUserEnter   // THIS IS how you get current value of the app delegate boolean value
    
    /*
     
     Basically use this to put into the daily called functijon if the user entered any of the sensors region or not and contingent upon that then upload data to firebase
     
     
     
     
     */
    
    
    //   let triggerManager = ESTTriggerManager()
    
    
   
    /*
     
     Todays work
     
       - reverse list
       - add functionality for every day 2 pm
       - notif should only work on weekday 
     
 
 
    */
    var timestampExist:Bool = false
    var checkDate: String = ""
    var nearableManager: ESTNearableManager
    var nearable: ESTNearable
    var databaseTimeStamp: Double = 0
    var broadcastingValue: ESTSettingNearableBroadcastingScheme
    var isComplete: Bool = false
    var periManager: CBPeripheralManager!
    var y: Int = 0
    var ref: DatabaseReference!
    var ref2: DatabaseReference!
    
    var locationValues: [String: Int] =  ["asia" : 0,
                                          "burger": 0,
                                          "homestyle": 0,
                                          "india" : 0]
    
    @IBOutlet weak var nearableLocation: UILabel!
    
    @IBOutlet weak var nearableSignal: UILabel!
    
    var user = Auth.auth().currentUser
    
    var email = Auth.auth().currentUser?.email
    
    //************************************************ **************************** ************* DEBUGGING CODE
    
    var  debugSignalStrengthArray: [Int] = []
    var debugRangedSensorTitle: [String] = []
    
    var locationArray: Array<Any>
    var locationDate: Array = [""]
    
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
        self.locationArray = [""]
        
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
        
        
    }
    
    
    /// TABLE VIEW delegated methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        let ref: DatabaseReference! = Database.database().reference()
        ref.child("final").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.childrenCount, "count of children")
            print(snapshot,"this IS THE CHILD")
            print(self.returnUserEntries(snapshot: snapshot), "this is new function value")
            
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let snapDict = snap.value as? NSDictionary
                
                let finalUserID = snapDict!["userID"]
                //finalUserID  as? String
                if  finalUserID  as? String  == Auth.auth().currentUser?.uid && self.y < self.returnUserEntries(snapshot: snapshot) {
                    
                    
                    self.y += 1
                }
            }
            
            
            
            
        })
        
        print(self.y, "this is the value of y")
        return self.y
    }
    
    
    func returnUserEntries(snapshot: DataSnapshot) -> Int {
        var totalValue: Int = 0
        
        
        for child in snapshot.children {
            let snap = child as! DataSnapshot
            let snapDict = snap.value as? NSDictionary
            
            let finalUserID = snapDict!["userID"]
            //finalUserID  as? String
            if  finalUserID  as? String  == Auth.auth().currentUser?.uid {
                
                totalValue += 1
            }
        }
        return totalValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DebugTableViewCell
        print(indexPath.count, "index path count")
        
        cell.nearableSensorTitle.text = self.locationArray[indexPath.row] as! String
        
        cell.signalStrengthTitle.text = self.locationDate[indexPath.row]
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
        
        // print(date.day, "This is the current weekday")
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
        
        
        //   tableView.dataSource = self //REMOVE AFTER TESTING
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
        
        
        
        
        
        
        runNotification()
        runCode2PM()
       // getData()
        translateUnixTime(time: 1515448224 )
        updateLocationArrayValues()
        updateLocationDates()
        
    }
    
    func updateLocationArrayValues() {
        
        let ref: DatabaseReference! = Database.database().reference()
        //  ref.child("XYSENSORS").observe(.value) { snapshot in
        ref.child("final").observe(.value) { (snapshot) in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let snapDict = snap.value as? NSDictionary
                let finalUserID = snapDict!["userID"]
                let finalLocation = snapDict!["location"]
                let finalTimestamp = snapDict!["timestamp"]
                
                if  (finalUserID as AnyObject) as? String == Auth.auth().currentUser?.uid {
                    self.locationArray.append(finalLocation as! String)
                    self.locationArray.reverse()
                    
                    
                }
            }
        }
        
    }
    
    
    func updateLocationDates() {
        
        let ref: DatabaseReference! = Database.database().reference()
        //  ref.child("XYSENSORS").observe(.value) { snapshot in
        ref.child("final").observe(.value) { (snapshot) in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let snapDict = snap.value as? NSDictionary
                let finalUserID = snapDict!["userID"]
                let finalLocation = snapDict!["location"]
                let finalTimestamp = snapDict!["timestamp"]
                
                if  (finalUserID as AnyObject) as? String == Auth.auth().currentUser?.uid {
                    
                    var updatedLocation: String = self.convertIntoReadable(time: finalTimestamp as! Double)
                    self.locationDate.append(updatedLocation)
                    self.locationDate.reverse()
                    
                }
            }
        }
        
    }
    
    
    
    
    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateTimer() {
        
        
    }
    
    
    func runNotification() {  // need to create 5 different notifications
        
        var date2 = DateComponents()
        let content = UNMutableNotificationContent()
        content.title = "Almoste time for lunch"
        content.body = "Swipe to keep in background"
        
        content.sound = UNNotificationSound.default()
            createNotification(index: 1, content: content)
        print(date2.weekday)
        
        //        let trigger = UNCalendarNotificationTrigger(dateMatching: date2, repeats: true)
        //        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
        //        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
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
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    func nearableManager(_ manager: ESTNearableManager, didExitIdentifierRegion identifier: String) {
        
        print("you left the region ******** BYE BYE ")
        
        
        
        self.nearableManager.startRanging(forIdentifier: identifier)
        self.nearableManager.startMonitoring(forIdentifier: identifier)
        
        
    }
    
    
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        
        //
        if peripheral.state == .poweredOn {
            print("powerd on")
        }
        if peripheral.state == .poweredOff {
            
            
            
            
        }
    }
    
    
       @objc func getData() { // have this function everyday at 2 PM
    
        let userID:String = Auth.auth().currentUser!.uid
        
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
                let user  = dict!["userID"]
                let date = dict!["timestamp"]
                let userLocation = dict!["location"]
                //== userID
    if (user as! AnyObject) as! String == userID  && (self.translateUnixTime(time: date as! Double) == self.translateUnixTime(time: self.getCurrentUnixTime())){
                    self.databaseTimeStamp = date as! Double
                    for (locationStation, timeIncrementer) in self.locationValues {
                        if (locationStation == userLocation as! String) {
                            var x: Int = timeIncrementer
                            x += 1
                            self.locationValues.updateValue(x, forKey: locationStation)
                        }
                    }
                    print(user , "this is the userID")
                    print(date , "this is the data of the user")
                    print(userLocation, "This is the location of the user")
                    
                    let currentTime = date
                    
                    
                }
                
                
                
            }
            
            
            self.sendToDataBase(time: self.databaseTimeStamp) // do GCD here
            self.locationValues.updateValue(0, forKey: "asia")
            self.locationValues.updateValue(0, forKey: "india")
            self.locationValues.updateValue(0, forKey: "burger")
            self.locationValues.updateValue(0, forKey: "homestyle")
            
            
            
        })
        
    }
    
    
    
    //    let everything: NSDictionary
    //    everything = [
    //    "userID" : self.user!.uid,
    //    "RSSI": (nearable.rssi),
    //    "timestamp": Int(Date().timeIntervalSince1970),
    //    "location" : nearableInformation[nearable.identifier]!["location"]!
    //    ]
    //    let ref = Database.database().reference().child("Everything").childByAutoId()
    //    //   let ref = Database.database().reference().child("TESTING").childByAutoId()
    //    ref.setValue(everything)
    
    func sendToDataBase(time: Double) { // do a check if time does not equal to zero
        
        if time != 0 {
            var max: Int = 0
            var maxLocation: String = ""
            for(locationStation, timeIncrementer) in self.locationValues {
                print(locationStation, timeIncrementer)
                if timeIncrementer >= max {
                    max = timeIncrementer
                    maxLocation = locationStation
                }
            }
            
            let final: NSDictionary
            final = [
                "userID" :  Auth.auth().currentUser!.uid,
                //  "userID" :  "hIp8zCKqYjTCck13JFAeCYWwBIo2",
                "location" : maxLocation,
                "timestamp" : time
                
            ]
            
            
             var ref2: DatabaseReference! = Database.database().reference()
            ref2.child("final").observe(.value) { snapshot in
                // check if time already exists in the database that your about to send to
                
                for child in snapshot.children{
                    
                    let snap = child as! DataSnapshot
                    let dict = snap.value as? NSDictionary
                    let date = dict!["timestamp"]
                    
                    if date as! Double  == time {  // check if it already exists in the database
                        
                        self.timestampExist = true
                        
                    } else {
                        self.timestampExist = false
                    }
                    
                }
            }
            
            
            if translateUnixTime(time: time) != self.checkDate && self.timestampExist == false {
                self.checkDate = translateUnixTime(time: time)
                print(max, maxLocation)
                let ref = Database.database().reference().child("final").childByAutoId()
                ref.setValue(final)
                
            }
            
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
    
    func getCurrentUnixTime() -> Double {
        
        let timestamp = NSDate().timeIntervalSince1970
        return timestamp
        
        
    }
    
    func translateUnixTime(time: Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: time )
        let dateFormatter = DateFormatter()
        // dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.dateFormat = "D"
        dateFormatter.timeZone = NSTimeZone(name: "PST") as! TimeZone
        
        let localDate = dateFormatter.string(from: date as Date)
        
        print(localDate)
        return localDate
        
        
    }
    
    
    func convertIntoReadable(time: Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: time )
        let dateFormatter = DateFormatter()
        // dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.dateFormat = "MM/DD/YYYY"
        dateFormatter.timeZone = NSTimeZone(name: "PST") as! TimeZone
        
        let localDate = dateFormatter.string(from: date as Date)
        
        print(localDate)
        return localDate
        
        
    }
    
    
    
    
    func getDateTime() -> String{
        let datetime = getReadableTimestamp("MM/dd/yyyy HH:mm:ss")
        return "[\(datetime)]"
    }
    
    
    func runCode2PM() {
        var date2 = DateComponents()
        date2.year = 2018
        date2.day = 17
        date2.month = 1
        date2.hour = 15
        date2.minute = 30
        
        
        var date = Date()
        let date3 = Calendar.current.date(from: date2)!
        
      //  print(date3)
     
        let timer = Timer(fireAt: date3, interval: 86400, target: self, selector: #selector(getData), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        
        
    }

    
    

    
    
}
 // Code for running results everyday at 2 PM






extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

