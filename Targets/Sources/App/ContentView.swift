//
//  ContentView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/4/25.
//

import SwiftUI
import Entity

struct ContentView: View {
    let dependencies: AppDependencies
    @StateObject private var dataStore: AppDataStore
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _dataStore = StateObject(wrappedValue: AppDataStore(routineDataUseCase: dependencies.routineDataUseCase))
    }
    
    var body: some View {
        TabView {
            RoutineHomeView(
                routines: dataStore.routines,
                dependencies: dependencies,
                onDataChanged: { dataStore.refresh() }
            )
                .tabItem {
                    Text("홈")
                    Image(systemName: "house.fill")
                }
            
            StatisticView(
                routineHistories: dataStore.routineHistories,
                routines: dataStore.routines
            )
                .tabItem {
                    Text("통계")
                    Image(systemName: "list.bullet.clipboard.fill")
                }
            
            RecommendView(dependencies: dependencies, routines: dataStore.routines)
                .tabItem {
                    Text("추천")
                    Image(systemName: "star.fill")
                }
        }
        .background(Color(.systemBackground))
        .onAppear {
            dataStore.refresh()
        }
    }
}

struct RoutineItemRow: View {
    let routineItem: RoutineItem
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(routineItem.emoji)
                Text(routineItem.title)
                    .font(.headline)
                Spacer()
                if routineItem.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
        }
    }
}

#Preview {
    ContentView(dependencies: .makePreview())
}
