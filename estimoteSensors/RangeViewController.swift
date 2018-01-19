//
//  RangeViewController.swift
//  estimoteSensors
//
//  Created by ishgupta on 7/25/17.
//  Copyright © 2017 ishgupta. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreMotion


class RangeViewController: GeoFenceCode,  EILIndoorLocationManagerDelegate{
    
    

    let locationManagerEstimote = EILIndoorLocationManager()
    let motionManager = CMMotionManager() // motion
    var timer:  Timer!
    
    var location: EILLocation!
    
    
    let asia = EILPoint(x: 6.37, y: 12.96)
    let india = EILPoint(x: 6.16, y: 0.62)
    let  burger = EILPoint(x: 0.59, y: 0.59)
    let homeStyle = EILPoint(x: 0.59, y: 13.47)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ESTConfig.setupAppID("caf-7az", andAppToken: "23c0e2454af572312419045a789a6340")
        
        
        // 3. Set the location manager's delegate
        self.locationManagerEstimote.delegate = self
        
        
        
        
        /*
         
         motionManager.startAccelerometerUpdates()
         motionManager.startGyroUpdates()
         motionManager.startMagnetometerUpdates()
         motionManager.startDeviceMotionUpdates()
         self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
         
         */
        
        
        
        
        
        
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "template")
        fetchLocationRequest.sendRequest { (location, error) in
            if location != nil {
                self.location = location!
                self.locationManagerEstimote.startPositionUpdates(for: self.location)
                print(location?.beacons)
                print(location?.area)
            } else {
                print("can't fetch location: \(error)")
            }
        }
    }
    
    
    
    
    
    /*
     @objc func update() {
     if let accelerometerData = motionManager.accelerometerData {
     print( "  Accelerometer Data  ", accelerometerData) // split data by white space
     
     //            struct Location {
     //                let latitude: Double
     //                let longitude: Double
     //
     //                // String in GPS format "44.9871,-93.2758"
     //                init(coordinateString: String) {
     //                    let crdSplit = coordinateString.characters.split(separator: " ")
     //                    latitude = atof(String(crdSplit.first!))
     //                    longitude = atof(String(crdSplit.last!))
     //                }
     //            }
     
     print("")
     }
     if let gyroData = motionManager.gyroData {
     print("  Gyro Data  ",gyroData)
     
     // FirebaseStruct(user: (Auth.auth().currentUser?.uid)!, timestamp: Int(Date().timeIntervalSince1970), xCoordinate: 99, yCoordinate: 99 )
     print("")
     }
     if let magnetometerData = motionManager.magnetometerData {
     print("  Magnetic Data  ",magnetometerData)
     print("")
     }
     if let deviceMotion = motionManager.deviceMotion {
     print("  Device Motion  ",deviceMotion)
     print("")
     }
     }
     
     
     */
    
    
    
    func indoorLocationManager(_ manager: EILIndoorLocationManager,
                               didFailToUpdatePositionWithError error: Error) {
        print("failed to update position: \(error)")
    }
    
    func indoorLocationManager(_ manager: EILIndoorLocationManager,
                               didUpdatePosition position: EILOrientedPoint,
                               with positionAccuracy: EILPositionAccuracy,
                               in location: EILLocation) {
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
        
    
        
        
        
        if position.distance(to: asia) < 3 {
            print("near computer")
            let x = FirebaseStruct(user: (Auth.auth().currentUser?.uid)!, timestamp: Int(Date().timeIntervalSince1970), xCoordinate: position.x, yCoordinate: position.y, location: "asia")
        }
        
        if position.distance(to: homeStyle) < 3 {
            print("near computer")
            let x = FirebaseStruct(user: (Auth.auth().currentUser?.uid)!, timestamp: Int(Date().timeIntervalSince1970), xCoordinate: position.x, yCoordinate: position.y, location: "homestyle")
        }
        
        if position.distance(to: india) < 3 {
            print("near computer")
            let x = FirebaseStruct(user: (Auth.auth().currentUser?.uid)!, timestamp: Int(Date().timeIntervalSince1970), xCoordinate: position.x, yCoordinate: position.y, location: "india")
        }
        
        if position.distance(to: burger) < 3 {
            print("near computer")
            let x = FirebaseStruct(user: (Auth.auth().currentUser?.uid)!, timestamp: Int(Date().timeIntervalSince1970), xCoordinate: position.x, yCoordinate: position.y, location: "burger")
        }
        
        
        
    }
    
    
  
    
    
    
}
