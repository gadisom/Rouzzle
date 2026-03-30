//
//  RoutinePersistenceMapper.swift
//  Rouzzle_iOS
//

import Foundation
import Entity 

enum RoutinePersistenceMapper {
    static func mapToDomain(_ stored: StoredRoutineItem) -> RoutineItem {
        let routine = RoutineItem(
            id: stored.id,
            title: stored.title,
            emoji: stored.emoji,
            dayStartTime: stored.dayStartTime,
            repeatCount: stored.repeatCount,
            interval: stored.interval,
            alarmIDs: stored.alarmIDs
        )
        var taskLookup: [UUID: TaskList] = [:]
        routine.taskList = stored.taskList.map { storedTask in
            let task = TaskList(
                id: storedTask.id,
                title: storedTask.title,
                emoji: storedTask.emoji,
                timer: storedTask.timer,
                isCompleted: storedTask.isCompleted
            )
            task.routineItem = routine
            task.taskHistories = storedTask.taskHistories.map {
                TaskHistory(
                    id: $0.id,
                    isCompleted: $0.isCompleted,
                    task: task
                )
            }
            taskLookup[storedTask.id] = task
            return task
        }
        
        for storedHistory in stored.history {
            let history = RoutineHistory(
                id: storedHistory.id,
                date: storedHistory.date,
                routine: routine
            )
            history.taskHistories = storedHistory.taskHistories.compactMap { storedHistoryTask in
                guard let taskId = storedHistoryTask.task?.id else {
                    return nil
                }
                    return TaskHistory(
                        id: storedHistoryTask.id,
                        isCompleted: storedHistoryTask.isCompleted,
                        task: taskLookup[taskId],
                        routineHistory: history
                    )
                }
            routine.history.append(history)
        }
        
        return routine
    }
    
    static func mapToStoredModel(_ routine: RoutineItem) -> StoredRoutineItem {
        let storedRoutine = StoredRoutineItem(
            id: routine.id,
            title: routine.title,
            emoji: routine.emoji,
            dayStartTime: routine.dayStartTime,
            repeatCount: routine.repeatCount,
            interval: routine.interval,
            alarmIDs: routine.alarmIDs
        )
        
        storedRoutine.taskList = routine.taskList.map { task in
            let storedTask = StoredTaskList(
                id: task.id,
                title: task.title,
                emoji: task.emoji,
                timer: task.timer,
                isCompleted: task.isCompleted
            )
            storedTask.routineItem = storedRoutine
            storedTask.taskHistories = task.taskHistories.map { taskHistory in
                let storedTaskHistory = StoredTaskHistory(
                    id: taskHistory.id,
                    isCompleted: taskHistory.isCompleted
                )
                storedTaskHistory.task = storedTask
                return storedTaskHistory
            }
            return storedTask
        }
        
        storedRoutine.history = routine.history.map { history in
            let storedHistory = StoredRoutineHistory(
                id: history.id,
                date: history.date,
                routine: storedRoutine
            )
            storedHistory.taskHistories = history.taskHistories.compactMap { historyTask in
                mapToStoredModel(historyTask, routineHistory: storedHistory, routine: storedRoutine)
            }
            return storedHistory
        }
        
        return storedRoutine
    }
    
    static func mapToStoredModel(_ taskHistory: TaskHistory, routineHistory: StoredRoutineHistory?, routine: StoredRoutineItem?) -> StoredTaskHistory {
        let storedTaskHistory = StoredTaskHistory(
            id: taskHistory.id,
            isCompleted: taskHistory.isCompleted
        )
        storedTaskHistory.routineHistory = routineHistory
        
        if let taskId = taskHistory.task?.id {
            storedTaskHistory.task = routine?.taskList.first { $0.id == taskId }
        }
        
        return storedTaskHistory
    }
}
