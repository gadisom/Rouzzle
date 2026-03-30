import Foundation
import SwiftUI
import Domain

@Observable
final class RoutineHomeViewModel {
    private let quoteProvider: QuotesProviderProtocol
    var currentQuote: String

    init(quoteProvider: QuotesProviderProtocol) {
        self.quoteProvider = quoteProvider
        self.currentQuote = quoteProvider.provideQuote()
    }

    func updateQuote() {
        currentQuote = quoteProvider.provideQuote()
    }
}
