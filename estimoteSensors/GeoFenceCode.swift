//
//  ViewController.swift
//  CoordinateGeoFence
//
//  Created by ishgupta on 1/3/18.
//  Copyright © 2018 ishgupta. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import UserNotifications
import FirebaseAuth
import FirebaseDatabase


class GeoFenceCode: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound];
    
    
    
    @IBOutlet weak var labelOutlet: UILabel!
    
    
  //  @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        center.requestAuthorization(options: self.options) { (granted, error) in
            
        }
      //  self.mapView.delegate = self
        self.locationManager.delegate = self
        
        self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        
        
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        self.locationManager.startUpdatingLocation()
        
        
        
        
        
        
    }
    
    
    func setUpGeofence() {
        
        
        
        
        
        
        
        let templatesCenter = CLLocationCoordinate2DMake(37.3305, -121.8946)
        let templatesRegion = CLCircularRegion(center: templatesCenter, radius: 0.06, identifier: "templates")
        templatesRegion.notifyOnEntry = true
        templatesRegion.notifyOnExit = true
        
        locationManager.startMonitoring(for: templatesRegion)
        
        
        
     //   self.mapView.showsUserLocation = true;
        
        
        
        
        let templates = MKCircle(center: templatesCenter, radius: 0.01)
     //   self.mapView.add(templates)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Started Monitoring Region", region.identifier)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lastLocation: CLLocation = locations[locations.count - 1]
        print(lastLocation.altitude, "This is the current altitude")
        print(lastLocation.floor,"This is the current floor")
        print(lastLocation.horizontalAccuracy, "This is the horizontal accuracy")
        print(lastLocation.verticalAccuracy, "this is the vertical accuracy")
        print(lastLocation.coordinate, "COORDINATES")
        
        let notification = UNMutableNotificationContent()
        notification.title = "checking your location"
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false )
        let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
        
        let location: NSDictionary
        location = [                                                // ->>>>>>>>>>>>>> Place inside the didEnterRegionfunction 
            
            //  "userID" :  "hIp8zCKqYjTCck13JFAeCYWwBIo2",
            "altitude" :  lastLocation.altitude,
            "lat" :  lastLocation.coordinate.latitude,
            "long" : lastLocation.coordinate.longitude,
            "timestamp"   : Date().timeIntervalSince1970
            
            
        ]
        
        let ref4 = Database.database().reference().child("geofenceData").childByAutoId()
        ref4.setValue(location)
        
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        
        print(userLocation.coordinate, "this is the current coordinate of the user")
        
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        print(region.identifier)
        self.locationManager.requestAlwaysAuthorization()
        print("Entered Region")
      //  labelOutlet.text = "ENTERED"
        
        
        let alert = UIAlertController(title: "", message: "Entered Region", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
        let notification = UNMutableNotificationContent()
        notification.title = "You have entered the region \(region.identifier)"
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false )
        let request = UNNotificationRequest(identifier: "notification2", content: notification, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
       
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state ==  .inside {
            //  labelOutlet.text = "INSIDE"
        }
        
        if state == .outside {
            
  
        }
        
        if state == .unknown {
            
    
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit Region")
        labelOutlet.text = "EXIT"
        
        
        let alert = UIAlertController(title: "", message: "Exited Region", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
        let notification = UNMutableNotificationContent()
        notification.title = "You have exited the region \(region.identifier)"
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false )
        let request = UNNotificationRequest(identifier: "notification3", content: notification, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedAlways) {
            self.setUpGeofence()
            self.locationManager.allowsBackgroundLocationUpdates = true
            
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlayRenderer : MKCircleRenderer = MKCircleRenderer(overlay: overlay);
        overlayRenderer.lineWidth = 4.0
        overlayRenderer.strokeColor = UIColor(red: 7.0/255.0, green: 106.0/255.0, blue: 255.0/255.0, alpha: 1)
        overlayRenderer.fillColor = UIColor.clear
        return overlayRenderer
    }
    
    
    
    
    
    
}


