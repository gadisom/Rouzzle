import Foundation
import SwiftData
import Domain
import Data

enum AppCompositionRoot {
    @MainActor
    static func makeAppDependencies(modelContainer: ModelContainer) -> AppDependencies {
        AppDependencies(
            routineDataUseCase: RoutineDataUseCase(
                swiftDataService: SwiftDataServiceImpl(modelContainer: modelContainer)
            ),
            recommendTaskUseCase: RecommendTaskUseCase(
                recommendTaskService: RecommendTaskService()
            ),
            notificationService: NotificationManager(),
            quoteProvider: QuotesProvider()
        )
    }
}
