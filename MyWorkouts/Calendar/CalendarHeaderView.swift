//
//  CalendarHeaderView.swift
//  MyWorkouts
//
//  Created by EdwardElric on 2024/10/8.
//

import SwiftData
import SwiftUI


struct CalendarHeaderView: View {
    @State private var monthDate = Date.now
    @State private var years: [Int] = []
    @State private var selectedMonth = Date.now.monthInt
    @State private var selectedYear = Date.now.yearInt
    let months = Date.fullMonthNames
    @Query private var workouts: [Workout]
    @Query(sort: \Activity.name) private var activities: [Activity]
    @State private var selectedActivity: Activity?
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $selectedActivity) {
                    Text("All").tag(nil as Activity?)
                    ForEach(activities, id: \.self) { activity in
                        Text(activity.name).tag(activity as Activity?)
                    }
                }
                HStack{
                    Spacer()
                    Picker("", selection: $selectedYear) {
                        ForEach (years, id: \.self) { year in
                            Text(String(year))
                        }
                    }
                    Spacer()
                    Picker("", selection: $selectedMonth) {
                        ForEach(months.indices, id: \.self) { index in
                            Text(months[index]).tag(index + 1)
                        }
                    }
                    Spacer()
                }
                .buttonStyle(.bordered)
                CalendarView(date: monthDate, selectedActivity: selectedActivity)
                Spacer()
            }
            .navigationTitle("Tallies")
        }
        .onAppear {
            years = Array(Set(workouts.map {$0.date.yearInt}.sorted()))
        }
        .onChange(of: selectedYear) {
            updateDate()
        }
        .onChange(of: selectedMonth) {
            updateDate()
        }
    }
    func updateDate() {
        monthDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1))!
    }
}

#Preview {
    CalendarHeaderView()
        .modelContainer(Activity.preview)
}
