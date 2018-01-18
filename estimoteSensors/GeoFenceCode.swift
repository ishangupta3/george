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


class GeoFenceCode: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
     let locationManager = CLLocationManager()
     let geofenceRegionCenter = CLLocationCoordinate2DMake(37.3308983, -121.89334919999999);
      let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound];

    
    @IBOutlet weak var labelOutlet: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        center.requestAuthorization(options: self.options) { (granted, error) in
        
        }
        self.mapView.delegate = self
        self.locationManager.delegate = self
        
        self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        


        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
       
  
        self.locationManager.startUpdatingLocation()
  
        
        
        
          let date = NSDate(timeIntervalSince1970: 1515448224)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = NSTimeZone(name: "PST") as! TimeZone
        let localDate = dateFormatter.string(from: date as Date)
        print(localDate)
        print("x")
   
    }

    
    func setUpGeofence() {
        
        let geofenceRegionCenter = CLLocationCoordinate2DMake(37.331099188, -121.89324);
        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 3, identifier: "ishansDESK")
        geofenceRegion.notifyOnExit = true
        geofenceRegion.notifyOnEntry = true
   
        locationManager.startMonitoring(for: geofenceRegion)
        
    
        
        let homeCenter = CLLocationCoordinate2DMake(37.5634, -122.0457)
        let homeRegion = CLCircularRegion(center: homeCenter, radius: 3, identifier: "home")
        
        
        
//        homeRegion.notifyOnExit = true
//        homeRegion.notifyOnEntry = true
//
//        locationManager.startMonitoring(for: homeRegion)

        
        
        
        
        let otherSideCenter = CLLocationCoordinate2DMake(37.3305, -121.8935)
        let otherSideRegion = CLCircularRegion(center: otherSideCenter, radius: 3, identifier: "otherside")
        otherSideRegion.notifyOnEntry = true
        otherSideRegion.notifyOnExit = true
        
        locationManager.startMonitoring(for: otherSideRegion)
        
        
        
        
        
        
        
        
        
   
        
        
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let mapRegion = MKCoordinateRegion(center: geofenceRegionCenter, span: span)
        self.mapView.setRegion(mapRegion, animated: true)
        let regionCircle = MKCircle(center: geofenceRegionCenter, radius: 3)
        self.mapView.add(regionCircle)
        self.mapView.showsUserLocation = true;
        
       
        let regionHome = MKCircle(center: homeCenter, radius: 15)
        self.mapView.add(regionHome)
        
        
        let other = MKCircle(center: otherSideCenter, radius: 3)
        self.mapView.add(other)
        
        
      //  let rRectangle = MKPolygon(
        
        

        
    

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
        
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {

        
            print(userLocation.coordinate, "this is the current coordinate of the user")
        
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {

        
         self.locationManager.requestAlwaysAuthorization()
        print("Entered Region")
        labelOutlet.text = "ENTERED"
        
        
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
            labelOutlet.text = "INSIDE"
        }
        
        if state == .outside {
            
            labelOutlet.text = "OUTSIDE"
        }
        
        if state == .unknown {
            
            labelOutlet.text = "UNKOWN"
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


