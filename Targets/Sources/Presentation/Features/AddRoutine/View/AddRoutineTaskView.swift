//
//  AddRoutineTaskView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/12/25.
//

import SwiftUI
import Entity 

struct AddRoutineTaskView: View {
    @Bindable var viewModel: AddRoutineViewModel
    @State var routineByTime: RoutineCategoryByTime?
    @State private var isCustomTaskSheet: Bool = false
    @State private var newTaskDetents: Set<PresentationDetent> = [.fraction(0.25)]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    SelectedTaskListView(
                        selectedTask: $viewModel.routineTask,
                        onAddTaskTap: {
                            isCustomTaskSheet = true
                        },
                        minHeight: 280
                    )
                    .padding(.bottom, 20)
                    
                    RecommendTaskListView(recommendTask: $viewModel.recommendTodoTask) {
                        viewModel.getRecommendTask()
                    } taskAppend: { routineTask in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if let index = viewModel.routineTask.firstIndex(where: { $0.hashValue == routineTask.hashValue }) {
                                viewModel.routineTask.remove(at: index)
                            } else {
                                viewModel.routineTask.append(routineTask)
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            viewModel.getRecommendTask()
                        }
                    }
                    RouzzleButton(buttonType: .save) {
                        do {
                            try viewModel.saveRoutine()
                            viewModel.isCompleted.toggle()
                        } catch {
                            print("❌ 루틴 저장 실패: \(error.localizedDescription)")
                        }
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        .sheet(isPresented: $isCustomTaskSheet) {
            NewTaskSheet { recommendTask in
                let routineTask = recommendTask.toRoutineTask()
                withAnimation(.easeInOut(duration: 0.3)) {
                    if let index = viewModel.routineTask.firstIndex(where: { $0.hashValue == routineTask.hashValue }) {
                        viewModel.routineTask.remove(at: index)
                    } else {
                        viewModel.routineTask.append(routineTask)
                    }
                }
            }
            .presentationDetents(newTaskDetents)
        }
    }
}


struct SelectedTaskListView: View {
    
    @State private var showDeleteIcon = false
    @State private var draggedItem: RoutineTask?
    @Binding var selectedTask: [RoutineTask]
    let onAddTaskTap: () -> Void
    let minHeight: CGFloat
    
    var body: some View {
        VStack(spacing: 14) {
            if selectedTask.isEmpty {
                VStack(spacing: 12) {
                    Button {
                        onAddTaskTap()
                    } label: {
                        HStack(spacing: 8) {
                            Text("할일을 추가해 주세요")
                                .font(.ptRegular())
                                .foregroundStyle(.gray)
                            
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .center)
            } else {
                HStack {
                    Text("목록")
                        .font(.ptBold(size: 18))
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        Button {
                            showDeleteIcon.toggle()
                        } label: {
                            Image(systemName: showDeleteIcon ? "arrow.up.arrow.down" : "trash")
                                .foregroundColor(.gray)
                        }
                        
                        Button {
                            onAddTaskTap()
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.gray)
                        }
                    }
                }
                
                ForEach(selectedTask, id: \.self) { task in
                    if showDeleteIcon {
                        TaskStatusRow(
                            taskStatus: .pending,
                            emojiText: task.emoji,
                            title: task.title,
                            timeInterval: task.timer,
                            showEditIcon: .constant(false),
                            showDeleteIcon: $showDeleteIcon
                        ) {
                            selectedTask.removeAll(where: { $0.hashValue == task.hashValue })
                        }
                    } else {
                        TaskStatusRow(
                            taskStatus: .pending,
                            emojiText: task.emoji,
                            title: task.title,
                            timeInterval: task.timer,
                            showEditIcon: .constant(true),
                            showDeleteIcon: $showDeleteIcon
                        )
                        .onDrag {
                            draggedItem = task
                            return NSItemProvider()
                        }
                        .onDrop(of: [.text], delegate: AddTaskDropDelegate(item: task, items: $selectedTask, draggedItem: $draggedItem))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .top)
        .animation(.easeInOut(duration: 0.3), value: selectedTask)
    }
}

private struct AddTaskDropDelegate: DropDelegate {
    let item: RoutineTask
    @Binding var items: [RoutineTask]
    @Binding var draggedItem: RoutineTask?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem,
              draggedItem.hashValue != item.hashValue,
              let fromIndex = items.firstIndex(where: { $0.hashValue == draggedItem.hashValue }),
              let toIndex = items.firstIndex(where: { $0.hashValue == item.hashValue }) else { return }
        
        withAnimation {
            items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }
}

struct RecommendTaskListView: View {
    
    @Binding var recommendTask: [RecommendTodoTask]
    let refreshRecommend: () -> Void
    let taskAppend: (RoutineTask) -> Void
    var body: some View {
        VStack {
            HStack {
                Text("추천")
                    .font(.ptBold())
                Spacer()
                Button {
                    refreshRecommend()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.title3)
                }
            }
            
            if recommendTask.isEmpty {
                Text("추천 할 일을 모두 등록했습니다!")
                    .font(.ptRegular())
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 10) {
                    ForEach(recommendTask, id: \.self) { recommend in
                        TaskRecommendPuzzle(recommendTask: recommend) {
                            taskAppend(recommend.toRoutineTask())
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: recommendTask)
            }
        }
    }
}


#Preview {
    let dependencies = AppDependencies.makePreview()
    AddRoutineTaskView(viewModel: AddRoutineViewModel(
        routineDataUseCase: dependencies.routineDataUseCase,
        recommendTaskUseCase: dependencies.recommendTaskUseCase,
        notificationService: dependencies.notificationService
    ))
}
