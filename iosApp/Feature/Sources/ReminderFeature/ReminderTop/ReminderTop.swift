//
//  ReminderTop.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import ComposableArchitecture
import Foundation
import Helper
import Tagged
import Theme

public enum Filter {
    case today
    case hasDate
    case all
    case completed
}

@Reducer
public struct ReminderTop {
    @ObservableState
    public struct State {
        public var myLists: IdentifiedArrayOf<ReminderMyListModel>
        var filters: [Filter]
        public var filteredReminderGroups: IdentifiedArrayOf<ReminderMyListModel> {
            let allReminder = myLists.flatMap(\.reminders)
            return filters.map { filter -> ReminderMyListModel in
                switch filter {
                case .today:
                    return .init(id: .init(UUID()), name: "Today", icon: .clockFill, reminders: allReminder.filter { $0.date.map(isToday) ?? false }.toIdentifiedArray())
                case .hasDate:
                    return .init(id: .init(UUID()), name: "Scheduled", icon: .calendarCircleFill, reminders: allReminder.filter(\.date != nil).toIdentifiedArray())
                case .all:
                    return .init(id: .init(UUID()), name: "All", icon: .trayCircleFill, reminders: allReminder.filter(!\.isCompleted).toIdentifiedArray())
                case .completed:
                    return .init(id: .init(UUID()), name: "Completed", icon: .checkmarkCircleFill, reminders: allReminder.filter(\.isCompleted).toIdentifiedArray())
                }
            }.toIdentifiedArray()
        }

        private func isToday(date: Date) -> Bool {
            let calendar = Calendar.current
            return calendar.isDateInToday(date)
        }

        // TODO: デフォルト値をmock以外に変更
        public init(myLists: IdentifiedArrayOf<ReminderMyListModel> = .mock, filters: [Filter] = [.today, .all, .hasDate, .completed]) {
            self.myLists = myLists
            self.filters = filters
        }
    }

    public enum Action {
        case view(View)

        public enum View {
            case onAppear
            case groupTapped(ReminderMyListModel)
            case myListTapped(ReminderMyListModel)
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear), .view(.groupTapped), .view(.myListTapped):
                return .none
            }
        }
    }
}

extension ReminderTop.State {
    public static let mock: Self = .init(myLists: .mock, filters: [.all, .today, .hasDate, .completed])
}

extension IdentifiedArrayOf<ReminderMyListModel> {
  public static let mock: Self = [
    ReminderMyListModel(id: .init(),
                       name: "AAA",
                       icon: .calendarCircleFill,
                        reminders: [.init(), .init()]),
    ReminderMyListModel(id: .init(),
                       name: "AAA",
                       icon: .calendarCircleFill,
                        reminders: [.init(title: "111",
                                    isCompleted: false),
                              .init(title: "222",
                                    isCompleted: true)])
  ]
}
