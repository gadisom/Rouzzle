//
//  RecommendView.swift
//  Rouzzle_iOS
//
//  Created by Hyeonjeong Sim on 4/10/25.
//

import SwiftUI
import Entity
import Domain 

struct RecommendView: View {
    @State private var viewModel: RecommendViewModel
    @State private var allCheckBtn = false
    private let dependencies: AppDependencies
    let routines: [RoutineItem]
    
    init(dependencies: AppDependencies, routines: [RoutineItem]) {
        self.dependencies = dependencies
        self.routines = routines
        _viewModel = State(initialValue: RecommendViewModel(
            routineDataUseCase: dependencies.routineDataUseCase
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("추천")
                    .font(.ptSemiBold(size: 18))
                    .padding(.leading)
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
            
            RecommendCategoryView(selectedCategory: $viewModel.selectedCategory)
                .padding(.bottom, 25)
            
            RecommendCardListView(
                cards: $viewModel.filteredCards,
                selectedRecommendTask: $viewModel.selectedRecommend,
                isAllSelected: $allCheckBtn,
                routines: routines,
                addRoutine: { _, _, routine in
                    guard let selectedRoutine = routine else { return }
                    
                    for task in viewModel.selectedRecommend {
                        if !selectedRoutine.taskList.contains(where: { $0.title == task.title }) {
                            let newTask = task.toTaskList()
                            selectedRoutine.taskList.append(newTask)
                        }
                    }
                    
                    Task {
                        await viewModel.addTask(selectedRoutine)
                    }
                },
                dependencies: dependencies
            )
            Spacer()
        }
    }
}

#Preview {
    RecommendView(dependencies: .makePreview(), routines: RoutineItem.sampleData)
}
