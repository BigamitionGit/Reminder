//
//  ReminderModel.swift
//  Feature
//
//  Created by 細田大志 on 2025/01/16.
//
import Tagged
import ComposableArchitecture
import Foundation
import Theme

public struct ReminderModel: Equatable, Identifiable, Codable {
    public let id: Tagged<Self, UUID>
    public let myListId: ReminderMyListModel.ID
    public var title: String
    public var dueDate: DueDate?
    public var isCompleted: Bool
    public var isInvalid: Bool {
        title.isEmpty
    }
    public var isToday: Bool {
        guard let date = dueDate?.date else { return false }
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }
    public var isPastDue: Bool {
        guard let date = dueDate?.date else { return false }
        return date < Date()
    }

    public init(id: Tagged<Self, UUID>, myListId: ReminderMyListModel.ID, title: String = "", dueDate: DueDate? = nil, isCompleted: Bool = false) {
        self.id = id
        self.myListId = myListId
        self.title = title
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }

    public struct DueDate: Equatable, Codable {
        public var date: Date
        public var isYearMonthDayOnly: Bool

        public init(date: Date, isYearMonthDayOnly: Bool) {
            self.date = date
            self.isYearMonthDayOnly = isYearMonthDayOnly
        }
    }
}
