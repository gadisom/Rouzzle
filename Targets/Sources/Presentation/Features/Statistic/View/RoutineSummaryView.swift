//
//  RoutineSummaryView.swift
//  Rouzzle_iOS
//
//  Created by 김동경 on 4/2/25.
//

import SwiftUI
import Entity

struct RoutineSummaryView: View {
    let selectedRoutine: RoutineItem
    @Binding var month: Date

    var body: some View {
        VStack {
            SummaryCountView(selectedRoutine: selectedRoutine)
            HStack {
                Text("월간 요약")
                    .font(.ptBold())
                Spacer()
                RoutineMonthSelectorView(month: $month)
            }
            .padding(.horizontal)
            .padding(.bottom)
            CalendarView(month: $month, selectedRoutine: selectedRoutine)
        }
    }
}


