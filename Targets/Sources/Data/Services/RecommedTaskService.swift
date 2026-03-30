//
//  RecommedTaskService.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 4/24/25.
//

import Foundation
import Domain
import Entity

public final class RecommendTaskService: RecommendTaskServiceProtocol {
    public init() {} 
    public func fetchRecommendedTasks(time: Date, excluding titles: [String]) -> [RecommendTodoTask] {
        let timeSet = getTimeCategory(for: time)
        return RecommendTaskData.getRecommendedTasks(for: timeSet, excluding: titles)
    }

    private func getTimeCategory(for time: Date) -> TimeCategory {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        let totalMinutes = hour * 60 + minute

        switch totalMinutes {
        case 300..<720:
            return .morning
        case 720..<1080:
            return .afternoon
        case 1080..<1380:
            return .evening
        default:
            return .night
        }
    }
}
