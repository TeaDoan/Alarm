//
//  AlarmModelController.swift
//  Alarm
//
//  Created by Thao Doan on 5/14/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmModelController {
    static let shared = AlarmModelController()
    var alarms = [Alarm]()
    init() {
        alarms.self = load()
    }
    func addAlarm(fireTimeFromMidnight: TimeInterval, name: String) -> Alarm{
        let newAlarm = Alarm.init(fireTimeFromMidnight: fireTimeFromMidnight, name:name, enabled: true)
        alarms.append(newAlarm)
        return newAlarm
        
    }
    
    func update(alarm: Alarm, fireTimeFromMidnight: TimeInterval, name: String){
    
    alarm.name = name
    alarm.fireTimeFromMidnight = fireTimeFromMidnight
    }
    
    func delete(alarm:Alarm){
        
        guard let index = alarms.index(of: alarm) else {return}
        alarms.remove(at: index)
    }
        
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        
    }
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let urls = paths[0].appendingPathComponent("alram.json")
        return urls
        
    }
    func save() {
        
        let jsonEncoder = JSONEncoder()
        
        do {
            
            let data = try jsonEncoder.encode(alarms)
            try data.write(to: fileURL())
            
            
        } catch let error {
            print("Error saving urls : \(#function),\(error),\(error.localizedDescription)")
            
        }
        
    }
    
    func load() -> [Alarm] {
        let jsonDecoder  = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            try jsonDecoder.decode([Alarm].self, from: data)
            
            return alarms
        } catch let error {
            print("Error loading urls : \(#function),\(error),\(error.localizedDescription)")
        }
        return []
    }
    
}

protocol AlarmSchedule {
   func scheduleUserNotifications(for alarm: Alarm)
   func cancelUserNotifications(for alarm: Alarm)
    }

extension AlarmSchedule {
    func scheduleUserNotifications(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Time up! "
        content.body = "Your alarm \(alarm.name) is done"
        content.sound = UNNotificationSound.default()
        guard let fireDate = alarm.fireDate else {return}
        let dateComponent = Calendar.current.dateComponents([.hour,.minute,.second], from: fireDate)
        let dateTriger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let request = UNNotificationRequest.init(identifier: alarm.uuid, content: content, trigger: dateTriger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("\(error.localizedDescription)")
            }
        }
    }
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
        
    }
}

