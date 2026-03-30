//
//  StoredRoutineModels.swift
//  Rouzzle_iOS
//

import Foundation
import SwiftData

@Model
public final class StoredRoutineItem: Identifiable {
    @Attribute(.unique) public var id: UUID
    public var title: String
    public var emoji: String
    public var repeatCount: Int?
    public var interval: Int?
    public var dayStartTime: [Int: String]
    public var alarmIDs: [Int: String]?
    
    @Relationship(deleteRule: .cascade, inverse: \StoredTaskList.routineItem)
    public var taskList: [StoredTaskList]
    
    @Relationship(deleteRule: .cascade, inverse: \StoredRoutineHistory.routine)
    public var history: [StoredRoutineHistory]
    
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
        self.taskList = []
        self.history = []
    }
}

@Model
public final class StoredTaskList: Identifiable {
    @Attribute(.unique) public var id: UUID
    public var title: String
    public var emoji: String
    public var timer: Int
    public var elapsedTime: Int?
    public var isCompleted: Bool = false
    
    public var routineItem: StoredRoutineItem?
    
    @Relationship(deleteRule: .cascade, inverse: \StoredTaskHistory.task)
    public var taskHistories: [StoredTaskHistory]
    
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
        self.taskHistories = []
    }
}

@Model
public final class StoredRoutineHistory: Identifiable {
    @Attribute(.unique) public var id: UUID
    public var date: Date
    
    public var routine: StoredRoutineItem?
    
    @Relationship(deleteRule: .cascade, inverse: \StoredTaskHistory.routineHistory)
    public var taskHistories: [StoredTaskHistory]
    
    public init(id: UUID = UUID(), date: Date, routine: StoredRoutineItem? = nil) {
        self.id = id
        self.date = date
        self.routine = routine
        self.taskHistories = []
    }
}

@Model
public final class StoredTaskHistory: Identifiable {
    @Attribute(.unique) public var id: UUID
    
    public var task: StoredTaskList?
    
    public var isCompleted: Bool
    
    public var routineHistory: StoredRoutineHistory?
    
    public init(id: UUID = UUID(), isCompleted: Bool, task: StoredTaskList? = nil, routineHistory: StoredRoutineHistory? = nil) {
        self.id = id
        self.isCompleted = isCompleted
        self.task = task
        self.routineHistory = routineHistory
    }
}
