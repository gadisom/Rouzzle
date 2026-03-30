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
        AppCompositionRoot.makeAppDependencies(modelContainer: SampleData.shared.modelContainer)
    }
}
#endif
