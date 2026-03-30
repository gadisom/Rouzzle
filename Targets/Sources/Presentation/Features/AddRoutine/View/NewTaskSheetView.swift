//
//  NewTaskSheetView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/19/25.
//

import SwiftUI
import Entity 

struct NewTaskModel {
    var emoji: String?
    var text: String = ""
    var hour: Int = 0
    var min: Int = 0
    var second: Int = 0
    var errorMessage: String?
    var sheetType: SheetType = .task
}

enum SheetType: Hashable {
    case task
    case time
}

struct NewTaskSheet: View {
    let action: (RecommendTodoTask) -> Void
    
    @State private var vm: NewTaskModel = .init()
    @Environment(\.dismiss) private var dismiss
    @FocusState var focusField: SheetType?
    
    var body: some View {
        VStack {
            switch vm.sheetType {
            case .task:
                TaskInputView(text: $vm.text, emoji: $vm.emoji, focusField: _focusField) {
                    if vm.text.isEmpty {
                        vm.errorMessage = "할 일을 입력해 주세요."
                        return
                    }
                    let timer = vm.hour * 3600 + vm.min * 60 + vm.second
                    let task = RecommendTodoTask(emoji: vm.emoji ?? "🧩", title: vm.text, timer: timer)
                    action(task)
                    dismiss()
                }
                
                TimeSelectionView(
                    sheetType: $vm.sheetType,
                    hour: $vm.hour,
                    min: $vm.min,
                    second: $vm.second,
                    errorMessage: $vm.errorMessage,
                    focusField: _focusField
                )
                if vm.errorMessage != nil {
                    Text(vm.errorMessage ?? "")
                        .foregroundStyle(.red)
                }
                
            case .time:
                CustomTimePickerView(
                    hour: vm.hour,
                    min: vm.min,
                    second: vm.second
                ) {
                    focusField = .task
                    vm.sheetType = .task
                } comfirm: { hour, min, second in
                    focusField = .task
                    vm.hour = hour
                    vm.min = min
                    vm.second = second
                    vm.sheetType = .task
                }
                
            }
        }
        .animation(.smooth, value: vm.sheetType)
        .onAppear {
            focusField = .task
        }
        .padding()
    }
}

struct TaskInputView: View {
    @Binding var text: String
    @Binding var emoji: String?
    @FocusState var focusField: SheetType?
    var onAddTask: () -> Void
    var body: some View {
        HStack {
            EmojiButton(selectedEmoji: $emoji, emojiButtonType: .keyboard) { emoji in
                self.emoji = emoji
                focusField = .task
            }
            
            TextField("추가할 할 일을 입력해 주세요.", text: $text)
                .focused($focusField, equals: .task)
                .font(.ptRegular())
            
            Button(action: onAddTask) {
                Image(systemName: "arrow.up")
                    .bold()
                    .padding(8)
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .clipShape(Circle())
            }
        }
        .padding(.vertical, 8)
    }
}

struct TimeSelectionView: View {
    @Binding var sheetType: SheetType
    @Binding var hour: Int
    @Binding var min: Int
    @Binding var second: Int
    @Binding var errorMessage: String?
    @FocusState var focusField: SheetType?
    
    var formattedTime: String {
        var components: [String] = []
        
        if hour > 0 {
            components.append("\(hour)시간")
        }
        if min > 0 {
            components.append("\(min)분")
        }
        if second > 0 {
            components.append("\(second)초")
        }
        
        return components.joined(separator: " ")
    }
    
    var body: some View {
        HStack {
            if hour == 0 && min == 0 && second == 0 {
                Button {
                    focusField = nil
                    sheetType = .time
                } label: {
                    HStack {
                        Image(systemName: "gauge.with.needle")
                            .tint(.gray)
                        Text("지속 시간 없음")
                            .foregroundColor(.gray)
                    }
                }
            } else {
                HStack {
                    Image(systemName: "gauge.with.needle")
                        .foregroundColor(.accentColor)
                    HStack {
                        Button {
                            focusField = nil
                            sheetType = .time
                        } label: {
                            Text(" \(formattedTime)")
                        }
                        
                        Button {
                            withAnimation {
                                self.hour = 0
                                self.min = 0
                                self.second = 0
                            }
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                    .padding(8)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.gray, lineWidth: 1)
                    }
                }
            }
            Spacer()
        }
        .padding(.bottom, 16)
    }
}

struct CustomTimePickerView: View {
    
    @State private var hour: Int = 0
    @State private var min: Int = 0
    @State private var second: Int = 0
    let cancel: () -> Void
    let comfirm: (Int, Int, Int) -> Void
    
    init(
        hour: Int = 0,
        min: Int = 0,
        second: Int = 0,
        cancel: @escaping () -> Void = {},
        comfirm: @escaping (Int, Int, Int) -> Void = {_, _, _ in}
    ) {
        self.hour = hour
        self.min = min
        self.second = second
        self.cancel = cancel
        self.comfirm = comfirm
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    cancel()
                } label: {
                    Text("취소")
                        .foregroundStyle(.basic)
                }
                
                Spacer()
                
                Button {
                    comfirm(hour, min, second)
                } label: {
                    Text("완료")
                        .foregroundStyle(.basic)
                }
            }
            
            HStack {
                Picker("", selection: $hour) {
                    ForEach(0...5, id: \.self) {
                        Text("\($0) 시간").tag($0)
                    }
                }
                .pickerStyle(.wheel)
                
                Picker("", selection: $min) {
                    ForEach(0...59, id: \.self) {
                        Text("\($0) 분").tag($0)
                    }
                }
                .pickerStyle(.wheel)
                
                Picker("", selection: $second) {
                    ForEach(0...59, id: \.self) {
                        Text("\($0) 초").tag($0)
                    }
                }
                .pickerStyle(.wheel)
                
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    NewTaskSheet(action: { _ in
        
    })
}
