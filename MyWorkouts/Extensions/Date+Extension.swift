//
// Created for MyWorkouts
// by  Stewart Lynch on 2024-01-19
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch

import Foundation

extension Date {
    //  用于获取并存储当前日历设置的每周第一天的编号,可以通过设置firstDayOfWeek的值来改变想要一周的第一天从星期几开始，比如星期一开始就等于2。
    static var firstDayOfWeek = Calendar.current.firstWeekday
    static var capitalizedFirstLettersOfWeekdays: [String] {
        let calendar = Calendar.current
        //        let weekdays = calendar.shortWeekdaySymbols
        //
        //        return weekdays.map { weekday in
        //            guard let firstLetter = weekday.first else { return "" }
        //            return String(firstLetter).capitalized
        //        }
        var weekdays = calendar.shortWeekdaySymbols
        //  通过旋转星期几的数组，使其以指定的第一天开始，并将每个名称转换为首字母大写。
        if firstDayOfWeek > 1 {
            for _ in 1..<firstDayOfWeek {
                if let first = weekdays.first {
                    weekdays.append(first)
                    weekdays.removeFirst()
                }
            }
        }
        return weekdays.map { $0.capitalized }
    }
    
    static var fullMonthNames: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        return (1...12).compactMap { month in
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
            let date = Calendar.current.date(from: DateComponents(year: 2000, month: month, day: 1))
            return date.map { dateFormatter.string(from: $0) }
        }
    }
    
    //  1.Calendar.current：获取当前日历实例。
    //  2.dateInterval(of:.month,for:self)：调用dateInterval(of:.month,for:)方法，以当前日期self为基础，返回该日期所在月份的时间区间（DateInterval）。这个区间包含了该月的开始和结束日期。
    //  3.!.start：通过强制解包!，提取出这个时间区间的开始日期（即该月的第一天）。
    var startOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: self)!.start
    }
    
    var endOfMonth: Date {
        let lastDay = Calendar.current.dateInterval(of: .month, for: self)!.end //其实返回下个月的第一天
        return Calendar.current.date(byAdding: .day, value: -1, to: lastDay)! //用于计算一个月的天数
    }
    //  上一个月的第一天
    var startOfPreviousMonth: Date {
        let dayInPreviousMonth = Calendar.current.date(byAdding: .month, value: -1, to: self)!
        return dayInPreviousMonth.startOfMonth
    }
    //  返回这个月的天数
    var numberOfDaysInMonth: Int {
        Calendar.current.component(.day, from: endOfMonth)
    }
    //  返回当前月份开始日期之前的星期日的日期,这样做默认是把周日当作是一周开始的第一天。
    var sundayBeforeStart: Date {
        //  当前月份开始日期的星期几（1表示周日，2表示周一，依次类推）
        let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
        //  计算上一个星期日到当前月份开始日期的天数，比如开始日期是周一，就是2 - 1，也就是1天
        let numberFromPreviousMonth = startOfMonthWeekday - 1
        //  往前倒推天数得到相应的日期，- 负号，所以是往前推
        return Calendar.current.date(byAdding: .day, value: -numberFromPreviousMonth, to: startOfMonth)!
    }
    //  计算并返回该月第一天所在周的第一天
    var firstWeekDayBeforeStart: Date {
        let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
        //  计算 startOfMonth 所在周的第一天与 firstDayOfWeek 之间的差值。
        let numberFromPreviousMonth = startOfMonthWeekday - Self.firstDayOfWeek
        return Calendar.current.date(byAdding: .day, value: -numberFromPreviousMonth, to: startOfMonth)!
    }
    //  完整显示上个月的最后一周和这个月的日期
    var calendarDisplayDays: [Date] {
        var days: [Date] = []
        //  Current month days, 遍历将每一天加入数组
        for dayOffset in 0..<numberOfDaysInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfMonth)
            days.append(newDay!)
        }
        //  previous month days
        for dayOffset in 0..<startOfPreviousMonth.numberOfDaysInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfPreviousMonth)
            days.append(newDay!)
        }
        //  筛选上一月最后一周的的日期和这个月的日期，升序排列
        //  return days.filter { $0 >= sundayBeforeStart && $0 <= endOfMonth}.sorted(by: <)
        return days.filter { $0 >= firstWeekDayBeforeStart && $0 <= endOfMonth}.sorted(by: <)
    }
    //  提取这个月的月份数字，以便在日历视图中筛选不想要的月份
    var monthInt: Int {
        Calendar.current.component(.month, from: self)
    }
    var yearInt: Int {
        Calendar.current.component(.year, from: self)
    }
    var dayInt: Int {
        Calendar.current.component(.day, from: self)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    // Used to generate the mock data for previews
    // Computed property courtesy of ChatGPT
    var randomDateWithinLastThreeMonths: Date {
        let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: self)!
        let randomTimeInterval = TimeInterval.random(in: 0.0..<self.timeIntervalSince(threeMonthsAgo))
        let randomDate = threeMonthsAgo.addingTimeInterval(randomTimeInterval)
        return randomDate
    }
}
