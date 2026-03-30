//
//  Quotes.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import Foundation
import Domain

public final class QuotesProvider: QuotesProviderProtocol {
    private let quotes: [String]
    private var currentQuotes: [String]

    public init(quotes: [String]? = nil) {
        let sourceQuotes = quotes ?? Self.defaultQuotes
        self.quotes = sourceQuotes
        self.currentQuotes = sourceQuotes
    }

    private static let defaultQuotes: [String] = [
        "\"오늘 행복하지 않다면, 내일도 행복하기 어렵다\"",
        "\"위대한 일은 편안한 지대에서 이루어지지 않는다\"",
        "\"습관이란 어떤 일이든지 하게 만든다\"",
        "\"생활은 습관이 짜낸 천에 불과하다\"",
        "\"비범함은 무수한 평범함이 쌓인 결과물이다\"",
        "\"천 리 길도 한 걸음부터\"",
        "\"남을 이기려 하기보다 어제의 나를 이겨라\"",
        "\"꾸준함이 재능을 이긴다\"",
        "\"시간은 되돌릴 수 없으니 지금을 살아라\""
    ]

    public func provideQuote() -> String {
        if currentQuotes.isEmpty {
            currentQuotes = quotes
        }
        return currentQuotes.removeFirst()
    }
}
