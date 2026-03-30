//
//  TaskListView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 3/11/25.
//

import SwiftUI
import Entity

// TODO: - 루틴 삭제하기 뻑남, 루틴 수정하기 빈 화면

struct TaskListView: View {
    let routine: RoutineItem
    let dependencies: AppDependencies
    let onRoutineDataChanged: (() -> Void)?
    @Binding var path: NavigationPath
    @StateObject var viewModel: TaskListViewModel
    @State private var showTimerView = false
    @State private var isShowingRoutineSettingsSheet: Bool = false
    @State private var detents: Set<PresentationDetent> = [.fraction(0.12)]
    @State private var isShowingEditRoutineSheet: Bool = false
    @State private var isShowingDeleteAlert: Bool = false
    
    init(
        routine: RoutineItem,
        path: Binding<NavigationPath>,
        dependencies: AppDependencies,
        onRoutineDataChanged: (() -> Void)? = nil
    ) {
        self.routine = routine
        self._path = path
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
            HStack(alignment: .center) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.ptSemiBold(size: 20))
                }
                .frame(width: 36, height: 44)
                
                Spacer()
                
                Text("\(viewModel.routineItem.emoji) \(viewModel.routineItem.title)")
                    .font(.ptSemiBold(size: 18))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Button {
                    isShowingRoutineSettingsSheet.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.ptSemiBold(size: 20))
                }
                .frame(width: 36, height: 44)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .bottom) {
                        Label(viewModel.routineItem.todayStartTimeFormatted, systemImage: "clock")
                            .font(.ptMedium())
                            .foregroundStyle(Color.subHeadlineFontColor)
                        
                        Spacer()
                        
                        Button {
                            //isShowingAddTaskSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .font(.title)
                        }
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
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .font(.system(size: 28))
                                
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
                        }
                    }
                    
                    RouzzleButton(buttonType: .timerStart, disabled: viewModel.routineItem.taskList.isEmpty) {
                        showTimerView.toggle()
                        
                        viewModel.cancelTodayAlarms()
                    }
                    .padding(.horizontal)
                    
                    RecommendTaskListView(recommendTask: $viewModel.recommendTodoTask) {
                        viewModel.getRecommendTask()
                    } taskAppend: { routineTask in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if let index = viewModel.routineTask.firstIndex(where: { $0.hashValue == routineTask.hashValue }) {
                                viewModel.routineTask.remove(at: index)
                            } else {
                                viewModel.routineTask.append(routineTask)
                                viewModel.saveRoutineTasks(task: routineTask)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
        }
        .sheet(isPresented: $isShowingRoutineSettingsSheet) {
            RoutineSettingsSheet(
                isShowingEditRoutineSheet: $isShowingEditRoutineSheet,
                isShowingDeleteAlert: $isShowingDeleteAlert
            )
            .presentationDetents([.fraction(0.25)])
        }
        .onAppear {
            viewModel.getRecommendTask()
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
                path: $path
            )
        }
        .fullScreenCover(isPresented: $isShowingEditRoutineSheet) {
        
//            EditRoutineView(viewModel: EditRoutineViewModel(routine: routineStore.selectedRoutineItem!)) { _ in
//                routineStore.loadState = .completed
//                routineStore.toastMessage = "수정에 성공했습니다."
//                routineStore.fetchViewTask()
//            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        TaskListView(routine: RoutineItem.sampleData[0], path: .constant(NavigationPath()), viewModel: AddRoutineViewModel())
//    }
//}
