




import Foundation
import UserNotifications

@available(iOS 10.0, *)
struct notifStruct {
    
    var title: String
    var subtitle: String
    var body: String
    
    init(title: String, subtitle: String, body: String) {
        
        self.title = title
        self.subtitle = subtitle
        self.body = body
        
        let notification = UNMutableNotificationContent()
        notification.title =  title
        notification.subtitle = subtitle
        notification.body =  body
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false )
        let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
        
    }
    

    
}


func createNotification(index: Int, content: UNNotificationContent) {
    var date2 = DateComponents()
    var date3 = DateComponents()
    var date4 = DateComponents()
    var date5 = DateComponents()
    var date6 = DateComponents()
    
    date2.hour = 11
    date2.minute = 15      // MONDAY
    date2.weekday = 2
    
    date3.hour = 11
    date3.minute = 15     // TUESDAY
    date3.weekday = 3
    
    date4.hour = 11
    date4.minute = 15      // WEDNESDAY
    date4.weekday = 4
    
    date5.hour = 11
    date5.minute = 15      // THURSDAY
    date5.weekday = 5
    
    date6.hour = 11
    date6.minute = 15        // FRIDAY
    date6.weekday = 6
    
   
    
    
    
    
    
    print(date2.day)
    let trigger2 = UNCalendarNotificationTrigger(dateMatching: date2, repeats: true)
    let request2 = UNNotificationRequest(identifier: "NOTIF2", content: content, trigger: trigger2)
    UNUserNotificationCenter.current().add(request2, withCompletionHandler: nil)
    
    
    let trigger3 = UNCalendarNotificationTrigger(dateMatching: date3, repeats: true)
    let request3 = UNNotificationRequest(identifier: "NOTIF3", content: content, trigger: trigger3)
    UNUserNotificationCenter.current().add(request3, withCompletionHandler: nil)
    
    let trigger4 = UNCalendarNotificationTrigger(dateMatching: date4, repeats: true)
    let request4 = UNNotificationRequest(identifier: "NOTIF4", content: content, trigger: trigger4)
    UNUserNotificationCenter.current().add(request4, withCompletionHandler: nil)
    
    let trigger5 = UNCalendarNotificationTrigger(dateMatching: date5, repeats: true)
    let request5 = UNNotificationRequest(identifier: "NOTIF5", content: content, trigger: trigger5)
    UNUserNotificationCenter.current().add(request5, withCompletionHandler: nil)
    
    let trigger6 = UNCalendarNotificationTrigger(dateMatching: date6, repeats: true)
    let request6 = UNNotificationRequest(identifier: "NOTIF6", content: content, trigger: trigger6)
    UNUserNotificationCenter.current().add(request6, withCompletionHandler: nil)
    
  //  print(request)
    
}
