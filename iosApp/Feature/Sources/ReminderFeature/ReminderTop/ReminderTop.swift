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
        public var myGroups: IdentifiedArrayOf<ReminderGroupModel>
        var filters: [Filter]
        public var filteredReminderGroups: IdentifiedArrayOf<ReminderGroupModel> {
            let allReminder = myGroups.flatMap(\.list)
            return filters.map { filter -> ReminderGroupModel in
                switch filter {
                case .today:
                    return .init(id: .init(UUID()), name: "Today", icon: .clockFill, list: allReminder.filter { $0.date.map(isToday) ?? false }.toIdentifiedArray())
                case .hasDate:
                    return .init(id: .init(UUID()), name: "Scheduled", icon: .calendarCircleFill, list: allReminder.filter(\.date != nil).toIdentifiedArray())
                case .all:
                    return .init(id: .init(UUID()), name: "All", icon: .trayCircleFill, list: allReminder.filter(!\.isCompleted).toIdentifiedArray())
                case .completed:
                    return .init(id: .init(UUID()), name: "Completed", icon: .checkmarkCircleFill, list: allReminder.filter(\.isCompleted).toIdentifiedArray())
                }
            }.toIdentifiedArray()
        }

        private func isToday(date: Date) -> Bool {
            let calendar = Calendar.current
            return calendar.isDateInToday(date)
        }

        // TODO: デフォルト値をmock以外に変更
        public init(myGroups: IdentifiedArrayOf<ReminderGroupModel> = .mock, filters: [Filter] = [.today, .all, .hasDate, .completed]) {
            self.myGroups = myGroups
            self.filters = filters
        }
    }

    public enum Action {
        case view(View)

        public enum View {
            case onAppear
            case groupTapped(ReminderGroupModel)
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                state.myGroups = []
                return .none
            case .view(.groupTapped):
                return .none
            }
        }
    }
}

extension ReminderTop.State {
    public static let mock: Self = .init(myGroups: .mock, filters: [.all, .today, .hasDate, .completed])
}

extension IdentifiedArrayOf<ReminderGroupModel> {
  public static let mock: Self = [
    ReminderGroupModel(id: .init(),
                       name: "AAA",
                       icon: .calendarCircleFill,
                       list: [.init(), .init()]),
    ReminderGroupModel(id: .init(),
                       name: "AAA",
                       icon: .calendarCircleFill,
                       list: [.init(title: "111",
                                    isCompleted: false),
                              .init(title: "222",
                                    isCompleted: true)])
  ]
}
