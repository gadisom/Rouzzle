//
//  SwiftDataService.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/19/25.
//

import Foundation
import SwiftData
import Entity
import Domain

enum SwiftDataServiceError: Error {
    case saveFailed(Error)
    case deleteFailed(Error)
    case dataConversionFailed
}

/// 데이터 관련 작업(루틴, TaskList)을 관리하는 싱글톤 클래스
@MainActor
public final class SwiftDataServiceImpl: @preconcurrency SwiftDataServiceProtocol {
    let context: ModelContext

    public init(modelContainer: ModelContainer) {
        self.context = modelContainer.mainContext
    }
    
    public func fetchRoutines() throws -> [RoutineItem] {
        let fetchDescriptor = FetchDescriptor<StoredRoutineItem>(sortBy: [SortDescriptor(\.title)])
        let storedRoutines = try context.fetch(fetchDescriptor)
        return storedRoutines.map(RoutinePersistenceMapper.mapToDomain)
    }
    
    public func fetchRoutineHistories() throws -> [RoutineHistory] {
        let fetchDescriptor = FetchDescriptor<StoredRoutineHistory>(sortBy: [SortDescriptor(\.date)])
        let storedHistories = try context.fetch(fetchDescriptor)
        return storedHistories.compactMap { storedHistory in
            guard let storedRoutine = storedHistory.routine else { return nil }
            let routine = RoutinePersistenceMapper.mapToDomain(storedRoutine)
            return routine.history.first(where: { $0.id == storedHistory.id })
        }
    }
    
    // MARK: - 루틴 관련 메서드
    public func addRoutine(_ routine: RoutineItem) throws {
        let storedRoutine = RoutinePersistenceMapper.mapToStoredModel(routine)
        context.insert(storedRoutine)
        try saveContext()
    }
    
    public func addRoutineHistory(_ history: RoutineHistory) throws {
        guard let routineId = history.routine?.id else {
            throw SwiftDataServiceError.dataConversionFailed
        }
        
        guard let storedRoutine = try fetchRoutine(by: routineId) else {
            throw SwiftDataServiceError.dataConversionFailed
        }
        
        let storedHistory = StoredRoutineHistory(id: history.id, date: history.date, routine: storedRoutine)
        storedHistory.taskHistories = history.taskHistories.compactMap { taskHistory in
            RoutinePersistenceMapper.mapToStoredModel(taskHistory, routineHistory: storedHistory, routine: storedRoutine)
        }
        context.insert(storedHistory)
        storedRoutine.history.append(storedHistory)
        try saveContext()
    }
    
    public func deleteRoutine(_ routine: RoutineItem) throws {
        guard let storedRoutine = try fetchRoutine(by: routine.id) else {
            return
        }
        context.delete(storedRoutine)
        try saveContext()
    }
    
    public func deleteAllRoutines() throws {
        let fetchDescriptor = FetchDescriptor<StoredRoutineItem>()
        do {
            let userRoutines = try context.fetch(fetchDescriptor)
            for routine in userRoutines {
                context.delete(routine)
            }
            try saveContext()
        } catch {
            print("❌ SwiftData: 루틴 삭제 실패: \(error.localizedDescription)")
            throw SwiftDataServiceError.deleteFailed(error)
        }
    }
    
    public func resetRoutine(from routine: RoutineItem) throws {
        guard let storedRoutine = try fetchRoutine(by: routine.id) else {
            return
        }
        
        for task in storedRoutine.taskList {
            context.delete(task)
        }
        storedRoutine.taskList.removeAll()
        try saveContext()
    }
    
    public func updateRoutineHistory(_ history: RoutineHistory) throws {
        let historyId = history.id
        
        if let storedHistory = try fetchRoutineHistory(by: historyId) {
            if let routineId = history.routine?.id, let storedRoutine = try fetchRoutine(by: routineId) {
                storedHistory.routine = storedRoutine
            }
            
            for taskHistory in storedHistory.taskHistories {
                context.delete(taskHistory)
            }
            storedHistory.taskHistories = history.taskHistories.compactMap { taskHistory in
                RoutinePersistenceMapper.mapToStoredModel(taskHistory, routineHistory: storedHistory, routine: storedHistory.routine)
            }
            storedHistory.date = history.date
        }
        try saveContext()
    }
    
    // MARK: - Task 관련 메서드
    public func addTask(to routineItem: RoutineItem, task: TaskList) throws {
        guard let storedRoutine = try fetchRoutine(by: routineItem.id) else { return }
        
        let storedTask = StoredTaskList(
            id: task.id,
            title: task.title,
            emoji: task.emoji,
            timer: task.timer,
            isCompleted: task.isCompleted
        )
        storedTask.routineItem = storedRoutine
        storedRoutine.taskList.append(storedTask)
        context.insert(storedTask)
        try saveContext()
    }
    
    public func addTaskHistory(_ history: TaskHistory) throws {
        guard let routineHistoryId = history.routineHistory?.id,
              let storedRoutineHistory = try fetchRoutineHistory(by: routineHistoryId) else {
            return
        }
        
        let storedTaskHistory = StoredTaskHistory(
            id: history.id,
            isCompleted: history.isCompleted
        )
        if let taskId = history.task?.id {
            storedTaskHistory.task = storedRoutineHistory.routine?.taskList.first { $0.id == taskId }
        }
        storedTaskHistory.routineHistory = storedRoutineHistory
        context.insert(storedTaskHistory)
        storedRoutineHistory.taskHistories.append(storedTaskHistory)
        try saveContext()
    }
    
    public func deleteTask(from routineItem: RoutineItem, task: TaskList) throws {
        guard let storedRoutine = try fetchRoutine(by: routineItem.id),
              let taskIndex = storedRoutine.taskList.firstIndex(where: { $0.id == task.id }) else {
            return
        }
        
        let storedTask = storedRoutine.taskList[taskIndex]
        storedRoutine.taskList.remove(at: taskIndex)
        context.delete(storedTask)
        try saveContext()
    }
    
    // MARK: - Private Method
    private func saveContext() throws {
        do {
            try context.save()
            print("성공")
        } catch {
            print("❌ Failed to save context: \(error.localizedDescription)")
            throw SwiftDataServiceError.saveFailed(error)
        }
    }
    
    private func fetchRoutine(by id: UUID) throws -> StoredRoutineItem? {
        let descriptor = FetchDescriptor<StoredRoutineItem>(
            predicate: #Predicate { $0.id == id }
        )
        return try context.fetch(descriptor).first
    }
    
    private func fetchRoutineHistory(by id: UUID) throws -> StoredRoutineHistory? {
        let descriptor = FetchDescriptor<StoredRoutineHistory>(
            predicate: #Predicate { $0.id == id }
        )
        return try context.fetch(descriptor).first
    }
}
