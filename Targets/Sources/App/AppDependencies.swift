import Foundation
import Domain
import Data
struct AppDependencies {
    let routineDataUseCase: RoutineDataUseCaseProtocol
    let recommendTaskUseCase: RecommendTaskUseCaseProtocol
    let notificationService: NotificationServiceProtocol
    let quoteProvider: QuotesProviderProtocol
}

#if DEBUG
extension AppDependencies {
    @MainActor
    static func makePreview() -> AppDependencies {
        let modelContainer = SampleData.shared.modelContainer
        let routineDataUseCase = RoutineDataUseCase(swiftDataService: SwiftDataServiceImpl(modelContainer: modelContainer))
        let recommendTaskUseCase = RecommendTaskUseCase(recommendTaskService: RecommendTaskService())
        
        return AppDependencies(
            routineDataUseCase: routineDataUseCase,
            recommendTaskUseCase: recommendTaskUseCase,
            notificationService: NotificationManager(),
            quoteProvider: QuotesProvider()
        )
    }
}
#endif
