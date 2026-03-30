//
//  TaskListViewModel.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 4/24/25.
//

import SwiftUI
import Foundation
import Domain
import Entity 

final class TaskListViewModel: ObservableObject {
    
    private let routineDataUseCase: RoutineDataUseCaseProtocol
    private let recommendTaskUseCase: RecommendTaskUseCaseProtocol
    private let notificationService: NotificationServiceProtocol
    
    @Published var routineItem: RoutineItem
    @Published var recommendTodoTask: [RecommendTodoTask] = [] {
        didSet {
            print("Recommend: \(recommendTodoTask.count)")
        }
    }
    @Published var routineTask: [RoutineTask]
    
    init(
        routineItem: RoutineItem,
        routineDataUseCase: RoutineDataUseCaseProtocol,
        recommendTaskUseCase: RecommendTaskUseCaseProtocol,
        notificationService: NotificationServiceProtocol
    ) {
        self.routineItem = routineItem
        self.routineTask = routineItem.taskList.map{$0.toRoutineTask()}
        self.routineDataUseCase = routineDataUseCase
        self.recommendTaskUseCase = recommendTaskUseCase
        self.notificationService = notificationService
    }
    
    func saveRoutineTasks(task: RoutineTask) {
        try? routineDataUseCase.addTask(to: routineItem, task: task.toTaskList())
        getRecommendTask()
    }
    
    func deleteRoutine() {
        try? routineDataUseCase.deleteRoutine(routineItem)
    }
    
    func getRecommendTask() {
        guard let firstTime = routineItem.dayStartTime.first?.value, let time = firstTime.toDate() else {
            return
        }
        let routineTitles = routineItem.taskList.map { $0.title }
        recommendTodoTask = recommendTaskUseCase.fetchRecommendedTasks(time: time, excluding: routineTitles)
    }
    
    
    func addTask(from recommend: RecommendTodoTask, to routineItem: RoutineItem) {
        let task = recommend.toTaskList()
        try? routineDataUseCase.addTask(to: routineItem, task: task)
    }

    func cancelTodayAlarms() {
        notificationService.cancelTodayAlarms(for: routineItem)
    }
}
