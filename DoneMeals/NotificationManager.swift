//
//  NotificationManager.swift
//  DoneMeals
//
//  Created by RAK on 02/06/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    class func addTimeNotification() {
        let identifire = "mealTimeNotificationm2jfgg"
        let content = UNMutableNotificationContent()
        content.body = "식사 하셨나요?🤔"
        content.sound = UNNotificationSound.default
        
        let components = DateComponents(hour: 13, minute: 20)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            print(error?.localizedDescription ?? "")
            return
        }
        print("\(identifire)의 알림이 추가되었습니다.")
    }
}
