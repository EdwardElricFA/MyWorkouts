//
//  CalendarView.swift
//  Demo
//
//  Created by EdwardElric on 2024/10/2.
//

import SwiftData
import SwiftUI

struct CalendarView: View {
    let date: Date
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7) //布局
    //    let days = 1..<32
    @State private var days: [Date] = []
    let selectedActivity: Activity?
    @Query private var workouts: [Workout]
    @State private var counts = [Int : Int]()
    
    init(date: Date, selectedActivity: Activity?) {
        self.date = date
        self.selectedActivity = selectedActivity
        let endOfMonthAdjustment = Calendar.current.date(byAdding: .day, value: -1, to: date.endOfMonth)!
        let predicate = #Predicate<Workout> {$0.date >= date.startOfMonth && $0.date <= endOfMonthAdjustment}
        _workouts = Query(filter: predicate, sort: \Workout.date)
    }
    var body: some View {
        let color = selectedActivity == nil ? .blue: Color(hex: selectedActivity!.hexColor)!
        VStack {
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    Text(daysOfWeek[index])
                        .fontWeight(.bold)
                        .foregroundStyle(color)
                        .frame(maxWidth: .infinity)
                }
            }
            LazyVGrid(columns: columns) {
                ForEach(days, id: \.self) { day in
                    if day.monthInt != date.monthInt {
                        Text("")
                    } else  {
                        Text(day.formatted(.dateTime.day())) //格式化时间，显示日期数字
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                Circle()
                                    .foregroundStyle(
                                        Date.now.startOfDay == day.startOfDay
                                        ? .red.opacity(counts[day.dayInt] != nil ? 0.8 : 0.3)
                                        : color.opacity(counts[day.dayInt] != nil ? 0.8 :  0.3)
                                    )
                            )
                            .overlay(alignment: .bottomTrailing) {
                                if let count = counts[day.dayInt] {
                                    Image(systemName: count <= 50 ? "\(count).circle.fill" : "plus.circle.fill")
                                        .foregroundColor(.secondary)
                                        .imageScale(.medium)
                                        .background(
                                            Color(.systemBackground)
                                                .clipShape(.circle)
                                        )
                                        .offset(x: 5, y: 5)
                                }
                            }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            days = date.calendarDisplayDays
            setupCounts()
        }
        .onChange(of: date) {
            days = date.calendarDisplayDays
            setupCounts()
        }
        .onChange(of: selectedActivity) {
            setupCounts()
        }
    }
    
    func setupCounts() {
        var filterWorkouts = workouts
        if let selectedActivity {
            filterWorkouts = workouts.filter {$0.activity == selectedActivity}
        }
        let mappedItems = filterWorkouts.map {($0.date.dayInt, 1)} //元组
        counts = Dictionary(mappedItems,uniquingKeysWith: +) //将元组处理成字典
    }
}

#Preview {
    CalendarView(date: Date.now, selectedActivity: nil)
        .modelContainer(Activity.preview)
}


// 实现逻辑：
// 1.使用LazyVStack一个日历视图，确定一个月有多少天。
// 2.创建一个日期数组来填充日历
// 3.这个月的第一天/最后一天，上月最后一个周日是几号
// 4.筛选出所需要的日期
