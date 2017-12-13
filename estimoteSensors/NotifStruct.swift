




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
