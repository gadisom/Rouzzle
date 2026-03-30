//
//  NotificationServiceProtocol.swift
//  Rouzzle_iOS
//
//  Created by Copilot.
//

import Foundation
import Entity 

public protocol NotificationServiceProtocol {
    func requestNotificationPermission(completion: @escaping (Bool) -> Void)
    func nextTriggerDate(for weekday: Int, hour: Int, minute: Int) -> Date
    func scheduleNotification(id: String, routineTitle: String, weekday: Int, hour: Int, minute: Int)
    func scheduleRoutineNotification(routineID: String, routineTitle: String, schedule: [Int: Date], repetitionCount: Int, intervalMinutes: Int)
    func cancelTodayAlarms(for routine: RoutineItem)
}
