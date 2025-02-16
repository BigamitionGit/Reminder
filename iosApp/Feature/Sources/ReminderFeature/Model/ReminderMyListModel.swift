//
//  ReminderMyListModel.swift
//  Feature
//
//  Created by 細田大志 on 2025/01/16.
//
import Tagged
import ComposableArchitecture
import Foundation
import Theme
import Helper

public struct ReminderMyListsModel: Equatable, Identifiable, Codable {
    public let id: Tagged<Self, UUID>
    public var myLists: IdentifiedArrayOf<ReminderMyListModel>
}

public struct ReminderMyListModel: Equatable, Identifiable, Codable {
    public let id: Tagged<Self, UUID>
    public var name: String
    public var icon: SFSymbol
    public var reminders: IdentifiedArrayOf<ReminderModel>

    public init(id: Tagged<Self, UUID>, name: String, icon: SFSymbol, reminders: IdentifiedArrayOf<ReminderModel>) {
        self.id = id
        self.name = name
        self.icon = icon
        self.reminders = reminders
    }
}

extension ReminderMyListModel {
    private static let myListId = ReminderMyListModel.ID()
    static let mock = ReminderMyListModel(
        id: myListId,
        name: "AAA",
        icon: .calendarCircleFill,
        reminders: [
            .init(
                id: .init(),
                myListId: myListId,
                title: "111",
                dueDate: Calendar.current.createDate(year: 2024, month: 12, day: 1).map { .init(date: $0, isYearMonthDayOnly: false) },
                isCompleted: false),
            .init(
                id: .init(),
                myListId: myListId,
                title: "112",
                dueDate: Calendar.current.createDate(year: 2024, month: 12, day: 1).map { .init(date: $0, isYearMonthDayOnly: false) },
                isCompleted: false),
            .init(
                id: .init(),
                myListId: myListId,
                title: "113",
                dueDate: Calendar.current.createDate(year: 2024, month: 12, day: 11).map { .init(date: $0, isYearMonthDayOnly: false) },
                isCompleted: false),
            .init(
                id: .init(),
                myListId: myListId,
                title: "222",
                dueDate: Calendar.current.createDate(year: 2024, month: 11, day: 1).map { .init(date: $0, isYearMonthDayOnly: false) },
                isCompleted: true),
            .init(
                id: .init(),
                myListId: myListId,
                title: "333",
                dueDate: Calendar.current.createDate(year: 2025, month: 12, day: 1).map { .init(date: $0, isYearMonthDayOnly: false) },
                isCompleted: false),
            .init(
                id: .init(),
                myListId: myListId,
                title: "444",
                dueDate: Calendar.current.createDate(year: 2025, month: 11, day: 1).map { .init(date: $0, isYearMonthDayOnly: false) },
                isCompleted: true)
        ])
}

extension SharedKey where Self == FileStorageKey<ReminderMyListsModel>.Default {
  static var myLists: Self {
      Self[.fileStorage(URL.documentsDirectory.appending(component: "reminder-myLists.json")), default: .init(id: .init(), myLists: .mock)]
  }
}
