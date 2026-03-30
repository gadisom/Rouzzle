//
//  AppDataStore.swift
//  Rouzzle_iOS
//

import Foundation
import SwiftUI
import Entity
import Domain

@MainActor
final class AppDataStore: ObservableObject {
    @Published private(set) var routines: [RoutineItem] = []
    @Published private(set) var routineHistories: [RoutineHistory] = []
    
    private let routineDataUseCase: RoutineDataUseCaseProtocol
    
    init(routineDataUseCase: RoutineDataUseCaseProtocol) {
        self.routineDataUseCase = routineDataUseCase
    }
    
    func refresh() {
        routines = (try? routineDataUseCase.fetchRoutines()) ?? []
        routineHistories = (try? routineDataUseCase.fetchRoutineHistories()) ?? []
    }
}
