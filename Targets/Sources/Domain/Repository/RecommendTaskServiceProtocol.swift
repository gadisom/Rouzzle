//
//  RecommendTaskServiceProtocol.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 4/24/25.
//

import Foundation
import Entity

public protocol RecommendTaskServiceProtocol {
    func fetchRecommendedTasks(time: Date, excluding titles: [String]) -> [RecommendTodoTask]
}
