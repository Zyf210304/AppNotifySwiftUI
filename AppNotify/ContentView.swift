//
//  ContentView.swift
//  AppNotify
//
//  Created by 张亚飞 on 2021/1/23.
//

import SwiftUI
import UserNotifications


struct ContentView: View {
    var body: some View {
        Home()
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





struct Home : View {
    
    @State var delegate = NotificationDelegate()
//    @State var testStr : String = "test"
    var body: some View {
        
        Text(delegate.textStr)
        Button(action: createNotofocation, label: {
            Text("Notify User")
        })
        .onAppear(perform: {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (_, _) in
            }
            
            UNUserNotificationCenter.current().delegate = delegate
        })
        .alert(isPresented: $delegate.alert, content: {
            Alert(title: Text("Message"), message: Text("Reply Button Is Pressed"), dismissButton: .destructive(Text("OK")))
        })
    }
    
    func createNotofocation(){
        
        let content = UNMutableNotificationContent()
        content.title = "Message"
        content.subtitle = "Notification From In-App From Kavsoft"
        //assigning to our notification....
        content.categoryIdentifier = "ACTIONS"
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let requset = UNNotificationRequest(identifier: "IN-App", content: content, trigger: trigger)
        
        
        //actions....
        let close = UNNotificationAction(identifier: "CLOSE", title: "Close", options: .destructive)
        let reply = UNNotificationAction(identifier: "REPLY", title: "Reply", options: .foreground)
        let category = UNNotificationCategory(identifier: "ACTIONS", actions: [close, reply], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        UNUserNotificationCenter.current().add(requset, withCompletionHandler: nil)
        
    }
    
    
    
}

class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    @Published var alert = false
    @Published var textStr = "123"
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.badge, .banner, .sound])
    }
    
    // listening to actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "REPLY" {
            print("reply the comment or do anything")
            self.alert.toggle()
            self.textStr = "123123"
        }
        
        completionHandler()
    }
}

