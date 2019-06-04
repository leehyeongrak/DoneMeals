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
    class func addTimeNotification(bld: Bld, date: Date) {
        let identifire = "\(bld)Notification"
        let content = UNMutableNotificationContent()
        content.body = "식사 하셨나요?🤔"
        content.sound = UNNotificationSound.default
        
        let calender = Calendar.current
        let components = calender.dateComponents([.minute, .hour], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            print(error?.localizedDescription ?? "")
            return
        }
        print("\(identifire)의 알림이 추가되었습니다.")
    }
    
    class func removeTimeNotification(bld: Bld) {
        let identifire = "\(bld)Notification"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifire])
        print("\(identifire)의 알림이 삭제되었습니다.")
    }
}
