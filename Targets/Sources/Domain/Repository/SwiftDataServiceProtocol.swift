//
//  SwiftDataServiceProtocol.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 4/24/25.
//

import Foundation
import Entity

public protocol SwiftDataServiceProtocol {
    func fetchRoutines() throws -> [RoutineItem]
    func fetchRoutineHistories() throws -> [RoutineHistory]
    func addRoutine(_ routine: RoutineItem) throws
    func deleteRoutine(_ routine: RoutineItem) throws
    func deleteAllRoutines() throws
    func resetRoutine(from routine: RoutineItem) throws
    func addTask(to routineItem: RoutineItem, task: TaskList) throws
    func deleteTask(from routineItem: RoutineItem, task: TaskList) throws
    func addRoutineHistory(_ history: RoutineHistory) throws
    func addTaskHistory(_ history: TaskHistory) throws
    func updateRoutineHistory(_ history: RoutineHistory) throws
}
