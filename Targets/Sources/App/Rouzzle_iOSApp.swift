//
//  Rouzzle_iOSApp.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/4/25.
//

import SwiftUI
import SwiftData
import UserNotifications
import Data 
@main
struct Rouzzle_iOSApp: App {
    let modelContainer: ModelContainer
    let appDependencies: AppDependencies
    
    init() {
        do {
#if DEBUG
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil { // 프리뷰에서 사용될 모델 컨테이너 
                let config = ModelConfiguration(isStoredInMemoryOnly: true)
                modelContainer = try ModelContainer(for: StoredRoutineItem.self, StoredTaskList.self, StoredRoutineHistory.self, StoredTaskHistory.self, configurations: config)
            } else {
                modelContainer = try ModelContainer(for: StoredRoutineItem.self, StoredTaskList.self, StoredRoutineHistory.self, StoredTaskHistory.self)
            }
#else
            modelContainer = try ModelContainer(for: StoredRoutineItem.self, StoredTaskList.self, StoredRoutineHistory.self, StoredTaskHistory.self)
#endif
        } catch {
            fatalError("❌ ModelContainer 초기화 실패: \(error.localizedDescription)")
        }
        appDependencies = AppCompositionRoot.makeAppDependencies(modelContainer: modelContainer)
        setupNotificationDelegate()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(dependencies: appDependencies)
                .modelContainer(modelContainer)
        }
    }
    
    private func setupNotificationDelegate() {
        let center = UNUserNotificationCenter.current()
        if let delegate = appDependencies.notificationService as? UNUserNotificationCenterDelegate {
            center.delegate = delegate
        }
    }
}
