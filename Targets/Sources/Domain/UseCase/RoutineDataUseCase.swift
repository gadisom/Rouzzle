import Foundation
import Entity 

public protocol RoutineDataUseCaseProtocol {
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

@MainActor
public final class RoutineDataUseCase: RoutineDataUseCaseProtocol {
    private let swiftDataService: SwiftDataServiceProtocol
    
    public init(swiftDataService: SwiftDataServiceProtocol) {
        self.swiftDataService = swiftDataService
    }
    
    public func fetchRoutines() throws -> [RoutineItem] {
        try swiftDataService.fetchRoutines()
    }
    
    public func fetchRoutineHistories() throws -> [RoutineHistory] {
        try swiftDataService.fetchRoutineHistories()
    }

    public func addRoutine(_ routine: RoutineItem) throws {
        try swiftDataService.addRoutine(routine)
    }
    
    public func deleteRoutine(_ routine: RoutineItem) throws {
        try swiftDataService.deleteRoutine(routine)
    }
    
    public func deleteAllRoutines() throws {
        try swiftDataService.deleteAllRoutines()
    }
    
    public func resetRoutine(from routine: RoutineItem) throws {
        try swiftDataService.resetRoutine(from: routine)
    }
    
    public func addTask(to routineItem: RoutineItem, task: TaskList) throws {
        try swiftDataService.addTask(to: routineItem, task: task)
    }
    
    public func deleteTask(from routineItem: RoutineItem, task: TaskList) throws {
        try swiftDataService.deleteTask(from: routineItem, task: task)
    }
    
    public func addRoutineHistory(_ history: RoutineHistory) throws {
        try swiftDataService.addRoutineHistory(history)
    }
    
    public func addTaskHistory(_ history: TaskHistory) throws {
        try swiftDataService.addTaskHistory(history)
    }
    
    public func updateRoutineHistory(_ history: RoutineHistory) throws {
        try swiftDataService.updateRoutineHistory(history)
    }
}
