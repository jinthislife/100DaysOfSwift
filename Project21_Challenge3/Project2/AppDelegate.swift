//
//  AppDelegate.swift
//  Project2
//
//  Created by LeeKyungjin on 21/03/2019.
//  Copyright © 2019 reyaong. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerLocal()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleLocal()
    }

    func registerLocal() {
        let current = UNUserNotificationCenter.current()
        current.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Granted")
            } else {
                print("Rejected")
            }
        }
    }
    
    func scheduleLocal() {
        registerCategory()

        let current = UNUserNotificationCenter.current()
        current.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Want to have fun?"
        content.body = "Time to play with world flags!"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "flaggame"]
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 5
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        current.add(request)
    }

    func registerCategory() {
        let current = UNUserNotificationCenter.current()
        current.delegate = self
        
        let launch = UNNotificationAction(identifier: "Launch", title: "Go to flag game!", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [launch], intentIdentifiers: [])

        current.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        if let customData = userInfo["customData"] as? String {
            switch response.actionIdentifier {
            case "Launch":
                print("Launch \(customData)")
            default:
                break
            }
        }

        completionHandler()
    }
}

