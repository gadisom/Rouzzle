import Foundation
import Entity

public protocol RecommendTaskUseCaseProtocol {
    func fetchRecommendedTasks(time: Date, excluding titles: [String]) -> [RecommendTodoTask]
}

public final class RecommendTaskUseCase: RecommendTaskUseCaseProtocol {
    private let recommendTaskService: RecommendTaskServiceProtocol
    
    public init(recommendTaskService: RecommendTaskServiceProtocol) {
        self.recommendTaskService = recommendTaskService
    }
    
    public func fetchRecommendedTasks(time: Date, excluding titles: [String]) -> [RecommendTodoTask] {
        recommendTaskService.fetchRecommendedTasks(time: time, excluding: titles)
    }
}
