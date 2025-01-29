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

@Reducer
public struct ReminderTop {
    @ObservableState
    public struct State {
        @Shared(.myLists) public var myLists
        public var groups: IdentifiedArrayOf<ReminderGroupModel>
        public var groupsWithCount: [(ReminderGroupModel, Int)] {
            let allReminder = myLists.flatMap(\.reminders)
            return groups.map { group -> (ReminderGroupModel, Int) in
                switch group {
                case .today:
                    return (group, allReminder.filter { $0.date.map(isToday) ?? false }.count)
                case .hasDate:
                    return (group, allReminder.filter(\.date != nil).count)
                case .all:
                    return (group, allReminder.filter(!\.isCompleted).count)
                case .completed:
                    return (group, allReminder.filter(\.isCompleted).count)
                }
            }
        }

        private func isToday(date: Date) -> Bool {
            let calendar = Calendar.current
            return calendar.isDateInToday(date)
        }

        public init(groups: IdentifiedArrayOf<ReminderGroupModel> = [.today, .all, .hasDate, .completed]) {
            self.groups = groups
        }
    }

    public enum Action {
        case view(View)

        public enum View {
            case onAppear
            case groupTapped(ReminderGroupModel)
            case myListTapped(ReminderMyListModel.ID)
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
        ._printChanges()
    }
}

extension ReminderTop.State {
    public static let mock: Self = .init(groups: [.all, .today, .hasDate, .completed])
}

extension IdentifiedArrayOf<ReminderMyListModel> {
    private static let myListIds: [ReminderMyListModel.ID] = [.init(), .init()]
  public static let mock: Self = [
    ReminderMyListModel(
        id: myListIds[0],
        name: "AAA",
        icon: .calendarCircleFill,
        reminders: [
            .init(id: .init(), myListId: myListIds[0]),
            .init(id: .init(), myListId: myListIds[0])]),
    ReminderMyListModel(
        id: myListIds[1],
        name: "AAA",
        icon: .calendarCircleFill,
        reminders: [
            .init(id: .init(), myListId: myListIds[1], title: "111",
                  isCompleted: false),
            .init(id: .init(), myListId: myListIds[1], title: "222",
                  isCompleted: true)])
  ]
}
