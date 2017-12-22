//
//  AppDelegate.swift
//  estimoteSensors
//
//  Created by ishgupta on 6/23/17.
//  Copyright © 2017 ishgupta. All rights reserved.
//

import UIKit
import CoreData
import Firebase

import UserNotifications




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, EILBackgroundIndoorLocationManagerDelegate {

    var window: UIWindow?
    
    let backgroundIndoorManager = EILBackgroundIndoorLocationManager()
    
    let asia = EILPoint(x: 6.37, y: 12.96)
    let india = EILPoint(x: 6.16, y: 0.62)
    let  burger = EILPoint(x: 0.59, y: 0.59)
    let homeStyle = EILPoint(x: 0.59, y: 13.47)
    
 
    
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        FirebaseApp.configure()
        
        // Estimote Beacon Code
        
        
        ESTConfig.setupAppID("caf-7az", andAppToken: "23c0e2454af572312419045a789a6340")
        self.backgroundIndoorManager.delegate = self
        self.backgroundIndoorManager.requestAlwaysAuthorization()
        
        
        
        let fetchLocation = EILRequestFetchLocation(locationIdentifier: "template")
        fetchLocation.sendRequest { (location, error) in
            if let location = location {
                self.backgroundIndoorManager.startPositionUpdates(for: location)
            } else {
                print("can't fetch location: \(error)")
            }
        }
      
        
        
        // Estimote Beacon Code
        
        
        return true
    }
    
    
   
    
    func backgroundIndoorLocationManager(_ manager: EILBackgroundIndoorLocationManager, didUpdatePosition position: EILOrientedPoint, with positionAccuracy: EILPositionAccuracy, in location: EILLocation) {
       
        
         print(location.description())
         print(position.description())
        
        
        
        var accuracy: String!
        switch positionAccuracy {
        case .veryHigh: accuracy = "+/- 1.00m"
        case .high:     accuracy = "+/- 1.62m"
        case .medium:   accuracy = "+/- 2.62m"
        case .low:      accuracy = "+/- 4.24m"
        case .veryLow:  accuracy = "+/- ? :-("
        case .unknown:  accuracy = "unknown"
        }
        print(String(format: "x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@",
                     position.x, position.y, position.orientation, accuracy))
        
        print("B A C K G R O U N D   W O R K S")
        
        
        if position.distance(to: asia) < 2 {
            print("near asia")
            let i = FirebaseStruct(user: (Auth.auth().currentUser?.uid)!, timestamp: Int(Date().timeIntervalSince1970), xCoordinate: position.x, yCoordinate: position.y, location: "asia")
        }
        
        if position.distance(to: homeStyle) < 2 {
            print("near homestyle")
            let y = FirebaseStruct(user: (Auth.auth().currentUser?.uid)!, timestamp: Int(Date().timeIntervalSince1970), xCoordinate: position.x, yCoordinate: position.y, location: "homestyle")
        }
        
        if position.distance(to: india) < 2 {
            print("near  india")
            let z = FirebaseStruct(user: (Auth.auth().currentUser?.uid)!, timestamp: Int(Date().timeIntervalSince1970), xCoordinate: position.x, yCoordinate: position.y, location: "india")
        }
        
        if position.distance(to: burger) < 2 {
            print("near burger")
            let a = FirebaseStruct(user: (Auth.auth().currentUser?.uid)!, timestamp: Int(Date().timeIntervalSince1970), xCoordinate: position.x, yCoordinate: position.y, location: "burger")
        }
        
        
     
        
        
    }
    
    func backgroundIndoorLocationManager(
        _ locationManager: EILBackgroundIndoorLocationManager,
        didFailToUpdatePositionWithError error: Error) {
        
        
        print("BACKGROUND DOES NOT WORK: \(error.localizedDescription)")
        
        
        
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
       
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
       
     
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        
        
        
        let content = UNMutableNotificationContent()
        content.title = "Please swipe on Notification to keep app in background"
        content.body = "**This helps us to help you**"
        content.sound = UNNotificationSound.default()
        
        
        

        // let date 2 = Date.
        var date = DateComponents()
        date.hour = 2
        date.minute = 15
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "estimoteSensors")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

