//
//  StatisticView.swift
//  Rouzzle_iOS
//
//  Created by 김정원 on 1/10/25.
//

import SwiftUI
import Charts
import Entity

struct StatisticView: View {
    @State private var month: Date = Date()
    @State private var selectedRoutine: RoutineItem = StatisticUtil.summaryRoutine
    let routineHistories: [RoutineHistory]
    let routines: [RoutineItem]
  
    var body: some View {
        ScrollView(.vertical) {
            Text("통계")
                .font(.ptSemiBold(.title2))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    SelectedRoutineButton(title: "요약", selected: selectedRoutine == StatisticUtil.summaryRoutine) {
                        selectedRoutine = StatisticUtil.summaryRoutine
                    }
                    .padding(.leading)
                    
                    ForEach(routines, id: \.id) { routine in
                        let selected = routine == selectedRoutine
                        SelectedRoutineButton(title: routine.title, selected: selected) {
                            selectedRoutine = routine
                        }
                    }
                }
            }
            .padding(.bottom, 32)
            
            if(selectedRoutine == StatisticUtil.summaryRoutine) {
                RoutineMaxStreakView(routineHistories: routineHistories)
                HStack {
                    Text("월간 성공률")
                        .padding(.leading)
                        .font(.ptBold())
                    Spacer()
                    RoutineMonthSelectorView(month: $month)
                }
                    RoutinePercentageView(routinehistories: routineHistories, date: month)
            } else {
                RoutineSummaryView(selectedRoutine: selectedRoutine, month: $month)
            }
            Spacer()
        }
    }
}


#Preview {
    StatisticView(
        routineHistories: [],
        routines: RoutineItem.sampleData
    )
}
