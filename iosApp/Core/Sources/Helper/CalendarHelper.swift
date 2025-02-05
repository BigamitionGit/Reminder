//
//  CalendarHelper.swift
//  Core
//
//  Created by 細田大志 on 2025/02/03.
//

import Foundation

extension Calendar {
    public func getMonths(from date: Date, range: Range<Int>) -> [Date] {
        return range.compactMap { monthOffset in
            self.date(byAdding: .month, value: monthOffset, to: date)
        }
    }

    public func isSameMonth(date1: Date, date2: Date) -> Bool {
        let components1 = dateComponents([.year, .month], from: date1)
        let components2 = dateComponents([.year, .month], from: date2)
        return components1 == components2
    }
}
