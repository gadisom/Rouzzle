//
//  AddRoutineContainerView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/12/25.
//

import SwiftUI
import Entity

struct AddRoutineContainerView: View {
    private let dependencies: AppDependencies
    private let onRoutineSaved: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AddRoutineViewModel
    
    init(
        dependencies: AppDependencies,
        targetRoutine: RoutineItem? = nil,
        onRoutineSaved: @escaping () -> Void = {}
    ) {
        self.dependencies = dependencies
        self.onRoutineSaved = onRoutineSaved
        _viewModel = State(wrappedValue: AddRoutineViewModel(
            routineDataUseCase: dependencies.routineDataUseCase,
            recommendTaskUseCase: dependencies.recommendTaskUseCase,
            notificationService: dependencies.notificationService,
            targetRoutine: targetRoutine
        ))
    }
    
    var body: some View {
        VStack {
            HStack {
                if viewModel.step == .info {
                    Spacer()
                }
                Button {
                   goBack()
                } label: {
                    Image(systemName: viewModel.step == .info ? "xmark" : "chevron.left")
                }
                if viewModel.step != .info {
                    Spacer()
                }
            }
            .padding()
            
            ProgressView(value: viewModel.step.rawValue, total: 1.0)
                .progressViewStyle(.linear)
                .padding(.horizontal)

            switch viewModel.step {
            case .info:
                AddRoutineView(viewModel: viewModel)
            case .task:
                AddRoutineTaskView(viewModel: viewModel)
            }
            
            Spacer()
            .onChange(of: viewModel.isCompleted) {
                if viewModel.isCompleted {
                    onRoutineSaved()
                    dismiss()
                }
            }
        }
    }
    private func goBack() {
        switch viewModel.step {
        case .info:
            dismiss()
        case .task:
            viewModel.step = .info
        }
    }
}

#Preview {
     AddRoutineContainerView(dependencies: .makePreview())
}
