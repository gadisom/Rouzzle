//
//  RoutineListView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import SwiftUI
import Entity

// Main View
struct RoutineHomeView: View {
    var routines: [RoutineItem]
    let dependencies: AppDependencies
    let onDataChanged: () -> Void
    @State private var isShowingAddRoutineSheet: Bool = false
    @StateObject private var router = HomeRouter()
    @State private var routineHomeViewModel: RoutineHomeViewModel
    @State private var selectedFilter = false

    init(
        routines: [RoutineItem],
        dependencies: AppDependencies,
        onDataChanged: @escaping () -> Void
    ) {
        self.routines = routines
        self.dependencies = dependencies
        self.onDataChanged = onDataChanged
        _routineHomeViewModel = State(initialValue: RoutineHomeViewModel(quoteProvider: dependencies.quoteProvider))
    }

    var filteredRoutines: [RoutineItem] {
        if selectedFilter {
            let today = Calendar.current.component(.weekday, from: Date())
            return routines.filter { routine in
                routine.dayStartTime.keys.contains(today)
            }
        } else {
            return routines
        }
    }
    
    var body: some View {
        NavigationStack(path: $router.routes) {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        HStack {
                            Text("🧩 루틴 10일차 · 🔥 연속 성공 5일차")
                                .font(.ptLight(.caption2))
                                .foregroundStyle(.gray)
                            Spacer()
                            
                            Button {
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(.accent)
                            }
                            .frame(width: 36, height: 36)
                        }
                        .padding(.horizontal)
                        
                        HeaderView(quoteText: routineHomeViewModel.currentQuote)
                            .padding(.horizontal)

                        HStack {
                            RoutineFilterToggle(isToday: $selectedFilter)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Button(action: {isShowingAddRoutineSheet.toggle()}) {
                                Image(systemName: "plus")
                                    .font(.title2)
                            }
                        }
                        .padding(.horizontal)
                        
                        ForEach(filteredRoutines) { routine in
                            RoutineItemView(routine: routine) {
                                router.push(.taskList(routine: routine))
                            }
                        }
                        
                        Button {
                            isShowingAddRoutineSheet.toggle()
                        } label: {
                            Image("RequestRoutine")
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(contentMode: .fit)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                }
            }
            .fullScreenCover(isPresented: $isShowingAddRoutineSheet) {
                    AddRoutineContainerView(
                        dependencies: dependencies,
                        onRoutineSaved: onDataChanged
                    )
            }
            .refreshable {
                routineHomeViewModel.updateQuote()
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case .taskList(let routine):
                    TaskListView(
                        routine: routine,
                        router: router,
                        dependencies: dependencies,
                        onRoutineDataChanged: onDataChanged
                    )
                }
            }
            
        }
    }
}

#Preview {
    RoutineHomeView(
        routines: RoutineItem.sampleData,
        dependencies: .makePreview(),
        onDataChanged: {}
    )
}
