//
//  ReminderTop.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import ComposableArchitecture
import Foundation
import Helper

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
        public var myGroups: IdentifiedArrayOf<ReminderGroup.State>
        var filters: [Filter]
        public var filteredReminderGroups: IdentifiedArrayOf<ReminderGroup.State> {
            let allReminder = myGroups.flatMap(\.list)
            return filters.map { filter -> ReminderGroup.State in
                switch filter {
                case .today:
                    return .init(id: UUID(), name: "Today", icon: .clockFill, list: allReminder.filter { $0.date.map(isToday) ?? false }.toIdentifiedArray())
                case .hasDate:
                    return .init(id: UUID(), name: "Scheduled", icon: .calendarCircleFill, list: allReminder.filter(\.date != nil).toIdentifiedArray())
                case .all:
                    return .init(id: UUID(), name: "All", icon: .trayCircleFill, list: allReminder.filter(!\.isCompleted).toIdentifiedArray())
                case .completed:
                    return .init(id: UUID(), name: "Completed", icon: .checkmarkCircleFill, list: allReminder.filter(\.isCompleted).toIdentifiedArray())
                }
            }.toIdentifiedArray()
        }

        private func isToday(date: Date) -> Bool {
            let calendar = Calendar.current
            return calendar.isDateInToday(date)
        }

        // TODO: デフォルト値をmock以外に変更
        public init(myGroups: IdentifiedArrayOf<ReminderGroup.State> = .mock, filters: [Filter] = []) {
            self.myGroups = myGroups
            self.filters = filters
        }
    }

    public enum Action {
        case view(View)
        case groups(IdentifiedActionOf<ReminderGroup>)

        public enum View {
            case onAppear
            case groupTapped(ReminderGroup.State)
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                state.myGroups = []
                return .none
            case .view(.groupTapped), .groups:
                return .none
            }
        }
        .forEach(\.myGroups, action: \.groups) {
            ReminderGroup()
        }
    }
}

extension IdentifiedArrayOf<ReminderGroup.State> {
  public static let mock: Self = [
    ReminderGroup.State(id: UUID(),
                        name: "AAA",
                        icon: .calendarCircleFill, list: [.init(id: UUID(),
                                                                   title: "111",
                                                                   date: nil,
                                                                   isCompleted: false),
                                                             .init(id: UUID(),
                                                                   title: "222",
                                                                   date: nil,
                                                                   isCompleted: true)]),
    ReminderGroup.State(id: UUID(),
                        name: "BBB",
                        icon: .checkmarkCircleFill, list: [.init(id: UUID(),
                                                                   title: "111",
                                                                   date: nil,
                                                                   isCompleted: false),
                                                             .init(id: UUID(),
                                                                   title: "222",
                                                                   date: nil,
                                                                   isCompleted: true)])
  ]
}
