//
//  TaskListView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 3/11/25.
//

import SwiftUI
import Entity

// TODO: - 루틴 삭제하기 뻑남

struct TaskListView: View {
    let routine: RoutineItem
    let dependencies: AppDependencies
    let onRoutineDataChanged: (() -> Void)?
    @ObservedObject var router: HomeRouter
    @StateObject var viewModel: TaskListViewModel
    @State private var showTimerView = false
    @State private var isShowingRoutineSettingsSheet: Bool = false
    @State private var detents: Set<PresentationDetent> = [.fraction(0.12)]
    @State private var isShowingEditRoutineSheet: Bool = false
    @State private var isShowingDeleteAlert: Bool = false
    
    init(
        routine: RoutineItem,
        router: HomeRouter,
        dependencies: AppDependencies,
        onRoutineDataChanged: (() -> Void)? = nil
    ) {
        self.routine = routine
        self.router = router
        self.dependencies = dependencies
        self.onRoutineDataChanged = onRoutineDataChanged
        _viewModel = StateObject(wrappedValue: TaskListViewModel(
            routineItem: routine,
            routineDataUseCase: dependencies.routineDataUseCase,
            recommendTaskUseCase: dependencies.recommendTaskUseCase,
            notificationService: dependencies.notificationService
        ))
    }
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Spacer()

                        Text("소요시간: \(totalDurationText)")
                            .font(.ptMedium())
                            .foregroundStyle(Color.subHeadlineFontColor)
                    }
                    .padding(.bottom, 5)
                    .padding(.horizontal)

                    if viewModel.routineItem.taskList.isEmpty {
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Text("할 일을 추가해보세요!")
                                    .font(.title2)
                                    .foregroundColor(.gray.opacity(0.5))
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 50)
                            Spacer()
                        }
                        .onTapGesture {
                            //  isShowingAddTaskSheet.toggle()
                        }
                    }
                    else {
                        ForEach(viewModel.routineItem.taskList) { task in
                            TaskStatusPuzzle(task: task)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom)
            }
            RouzzleButton(buttonType: .timerStart, disabled: viewModel.routineItem.taskList.isEmpty) {
                showTimerView.toggle()
                
                viewModel.cancelTodayAlarms()
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .sheet(isPresented: $isShowingRoutineSettingsSheet) {
            RoutineSettingsSheet(
                isShowingEditRoutineSheet: $isShowingEditRoutineSheet,
                isShowingDeleteAlert: $isShowingDeleteAlert
            )
            .presentationDetents([.fraction(0.25)])
        }
        .customAlert(
            isPresented: $isShowingDeleteAlert,
            title: "해당 루틴을 삭제합니다",
            message: "삭제 버튼 선택 시, 루틴 데이터는\n삭제되며 복구되지 않습니다.",
            primaryButtonTitle: "삭제",
            primaryAction: {
                viewModel.deleteRoutine()
                onRoutineDataChanged?()
                dismiss()
            }
        )
        .fullScreenCover(isPresented: $showTimerView) {
            // TODO: - 모두 완료되어 있을때 완료 상태를 초기화 해야한다. 아이템 완료상태 초기화 해서 보냄
            RoutineTimerView(
                viewModel: RoutineTimerViewModel(
                routine: viewModel.routineItem,
                routineDataUseCase: dependencies.routineDataUseCase
                ),
                onRoutineCompleted: {
                    showTimerView = false
                    router.popToRoot()
                }
            )
        }
        .fullScreenCover(isPresented: $isShowingEditRoutineSheet) {
            AddRoutineContainerView(
                dependencies: dependencies,
                targetRoutine: routine,
                onRoutineSaved: {
                    onRoutineDataChanged?()
                }
            )
        }
        .navigationTitle(viewModel.routineItem.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingRoutineSettingsSheet.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.ptSemiBold(size: 20))
                }
            }
        }
    }

    private var totalDurationText: String {
        let totalSeconds = viewModel.routineItem.taskList.reduce(0) { $0 + $1.timer }
        
        let totalMinutes = totalSeconds / 60
        let totalHours = totalMinutes / 60
        let remainMinutes = totalMinutes % 60
        let remainSeconds = totalSeconds % 60
        
        if totalMinutes == 0 {
            return "\(remainSeconds)초"
        }
        
        if totalHours == 0 {
            return "\(totalMinutes)분"
        }
        
        if remainMinutes == 0 && remainSeconds == 0 {
            return "\(totalHours)시간"
        }
        
        if remainSeconds == 0 {
            return "\(totalHours)시간 \(remainMinutes)분"
        }
        
        return "\(totalHours)시간 \(remainMinutes)분 \(remainSeconds)초"
    }
}

//#Preview {
//    NavigationStack {
//        TaskListView(routine: RoutineItem.sampleData[0], router: HomeRouter(), dependencies: AppDependencies.makePreview())
//    }
//}
