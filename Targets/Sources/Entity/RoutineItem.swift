//
//  RoutineItem.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import Foundation

public class RoutineItem: Identifiable {
    public let id: UUID
    public var title: String
    public var emoji: String
    public var repeatCount: Int?
    public var interval: Int?
    public var dayStartTime: [Int: String]
    public var alarmIDs: [Int: String]?
    public var taskList: [TaskList] = []
    public var history: [RoutineHistory] = []

    public init(
        id: UUID = UUID(),
        title: String,
        emoji: String,
        dayStartTime: [Int: String],
        repeatCount: Int? = nil,
        interval: Int? = nil,
        alarmIDs: [Int: String]? = nil
    ) {
        self.id = id
        self.title = title
        self.emoji = emoji
        self.dayStartTime = dayStartTime
        self.repeatCount = repeatCount
        self.interval = interval
        self.alarmIDs = alarmIDs
    }

    public var isCompleted: Bool {
        taskList.allSatisfy { $0.isCompleted }
    }
}

// TODO: 이름이 Task가 더 맞아보여요
public final class TaskList: Identifiable {
    public let id: UUID
    public var title: String
    public var emoji: String
    public var timer: Int
    public var elapsedTime: Int?
    // TODO: 여기의 isCompleted도 taskHistory에서
    public var isCompleted: Bool = false
    public var routineItem: RoutineItem?
    public var taskHistories: [TaskHistory] = []

    public init(
        id: UUID = UUID(),
        title: String,
        emoji: String,
        timer: Int,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.emoji = emoji
        self.timer = timer
        self.isCompleted = isCompleted
    }

    public func toRoutineTask() -> RoutineTask {
        RoutineTask(title: title, emoji: emoji, timer: timer)
    }
}

public final class RoutineHistory: Identifiable {
    public let id: UUID
    public var date: Date
    public var routine: RoutineItem?
    public var taskHistories: [TaskHistory] = []
    
    public init(
        id: UUID = UUID(),
        date: Date,
        routine: RoutineItem? = nil
    ) {
        self.id = id
        self.date = date
        self.routine = routine
    }

    /// 모든 task를 다 완료했는지
    public var isCompleted: Bool {
        taskHistories.allSatisfy { $0.isCompleted }
    }

    /// task 성공율(두 자리 정수)
    public var completeRate: Int {
        guard !taskHistories.isEmpty else { return 0 }
        let completedCount = taskHistories.filter { $0.isCompleted }.count
        return (completedCount * 100) / taskHistories.count
    }
}

public final class TaskHistory: Identifiable {
    public let id: UUID
    /// TaskList와의 관계 (어떤 Task인지 확인하기 위해)
    public var task: TaskList?
    /// 해당 Task의 완료 여부
    public var isCompleted: Bool
    /// RoutineHistory와의 관계: 해당 날짜의 루틴 수행 기록
    public var routineHistory: RoutineHistory?

    public init(
        id: UUID = UUID(),
        isCompleted: Bool,
        task: TaskList? = nil,
        routineHistory: RoutineHistory? = nil
    ) {
        self.id = id
        self.isCompleted = isCompleted
        self.task = task
        self.routineHistory = routineHistory
    }
}

extension RoutineItem: Equatable, Hashable {
    public static func == (lhs: RoutineItem, rhs: RoutineItem) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var todayStartTimeFormatted: String {
        let today = Date()
        let calendar = Calendar.current
        let weekdayNumber = calendar.component(.weekday, from: today)
        
        let rawTime = self.dayStartTime[weekdayNumber] ?? self.dayStartTime.first?.value ?? ""
        
        let period = rawTime.to12HourPeriod()
        let formattedTime = rawTime.to12HourFormattedTime()
        
        return period + " " + formattedTime
    }
}

extension TaskList: Equatable, Hashable {
    public static func == (lhs: TaskList, rhs: TaskList) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension RoutineHistory: Equatable, Hashable {
    public static func == (lhs: RoutineHistory, rhs: RoutineHistory) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension TaskHistory: Equatable, Hashable {
    public static func == (lhs: TaskHistory, rhs: TaskHistory) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
