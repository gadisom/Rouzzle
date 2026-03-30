//
//  EntityPreviewData.swift
//  Rouzzle_iOS
//
//  Created by Copilot.
//

import Foundation
import Entity

extension RoutineItem {
    static let sampleData: [RoutineItem] = [
        {
            let routine = RoutineItem(title: "아침 루틴", emoji: "🌅", dayStartTime: [1: "06:30"])
            routine.taskList = [
                TaskList(title: "기상하기", emoji: "⏰", timer: 5),
                TaskList(title: "스트레칭", emoji: "🤸", timer: 10)
            ]
            return routine
        }(),
        {
            let routine = RoutineItem(title: "저녁 루틴", emoji: "🌇", dayStartTime: [1: "20:00"])
            return routine
        }()
    ]
    
    static let sampleDataTaskList: [RoutineItem] = [
        {
            let routine = RoutineItem(title: "아침 루틴", emoji: "🚬", dayStartTime: [3: "06:30"])
            routine.taskList = TaskList.sampleData
            return routine
        }(),
        {
            let routine = RoutineItem(title: "저녁 루틴", emoji: "🍺", dayStartTime: [3: "12:00"])
            routine.taskList = TaskList.sampleData
            return routine
        }(),
        {
            let routine = RoutineItem(title: "운동 루틴", emoji: "💪🏼", dayStartTime: [1: "18:00"])
            routine.taskList = TaskList.sampleData
            return routine
        }()
    ]
}

extension TaskList {
    static let sampleData: [TaskList] = [
        TaskList(title: "밥 먹기", emoji: "🍚", timer: 3, isCompleted: true),
        TaskList(title: "양치 하기", emoji: "🪥", timer: 3, isCompleted: false),
        TaskList(title: "술 마시기", emoji: "🍺", timer: 30, isCompleted: false),
        TaskList(title: "음 그래 쉽지않아", emoji: "👺", timer: 30, isCompleted: true),
        TaskList(title: "이두 조져", emoji: "💪🏿", timer: 10, isCompleted: true),
        TaskList(title: "삼두 조져", emoji: "🦾", timer: 10, isCompleted: true),
        TaskList(title: "예비군", emoji: "🪖", timer: 10, isCompleted: true),
    ]
}

extension TaskHistory {
    static let sampleData: [TaskHistory] = [
        TaskHistory(isCompleted: true, task: TaskList.sampleData[0]),
        TaskHistory(isCompleted: true, task: TaskList.sampleData[1]),
    ]
}
