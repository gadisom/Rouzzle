//
//  HomeRouter.swift
//  Rouzzle_iOS
//
//  Created by Codex.
//

import Foundation
import SwiftUI

@MainActor
final class HomeRouter: ObservableObject {
    @Published var routes: [HomeRoute] = []
    
    func push(_ route: HomeRoute) {
        routes.append(route)
    }
    
    func pop() {
        _ = routes.popLast()
    }
    
    func popToRoot() {
        routes.removeAll()
    }
}

