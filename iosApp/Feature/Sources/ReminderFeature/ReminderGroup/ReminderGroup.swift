//
//  ReminderGroup.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import ComposableArchitecture
import Theme
import Foundation
import Helper
import Tagged

@Reducer
public struct ReminderGroup {

    public struct Section: Equatable, Identifiable {
        public let id: Tagged<Self, UUID> = .init()
        public let name: String?
        public var subSections: [SubSection]
    }
    public struct SubSection: Equatable, Identifiable {
        public let id: Tagged<Self, UUID> = .init()
        public let name: String?
        public var reminders: IdentifiedArrayOf<ReminderModel>
    }

    @ObservableState
    public struct State: Equatable {
        public let group: ReminderGroupModel
        @Shared(.myLists) var myLists: IdentifiedArrayOf<ReminderMyListModel>
        public var focus: ReminderModel.ID?
        public var sections: [Section] = []

        public init(group: ReminderGroupModel, focus: ReminderModel.ID? = nil) {
            self.group = group
            self.focus = focus
        }
    }

    public enum Action: BindableAction {
        case view(View)
        case `internal`(Internal)
        case binding(BindingAction<State>)

        public enum View {
            case onAppear
            case editDone
        }

        public enum Internal {
            case reminderUpdated(ReminderModel)
            case myListsUpdated(IdentifiedArrayOf<ReminderMyListModel>)
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
            .onChange(of: \.focus) { old, _ in
                Reduce { state, _ in
                    reminderUpdatedEffect(id: old, myLists: state.myLists)
                }
            }
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .publisher {
                    state.$myLists.publisher.map { Action.internal(.myListsUpdated($0)) }
                }
            case let .internal(.myListsUpdated(myLists)):
                state.sections = convert(group: state.group, myLists: myLists)
                return .none
            case let .internal(.reminderUpdated(reminder)):
                if reminder.isInvalid {
                    _ = state.$myLists.withLock { $0[id: reminder.myListId]?.reminders.remove(id: reminder.id) }
                }
                return .none
            case .view(.editDone):
                state.focus = nil
                return .none
            case .binding:
                return .none
            }
        }
        .onChange(of: \.focus) { old, _ in
            Reduce { state, _ in
                reminderUpdatedEffect(id: old, myLists: state.myLists)
            }
        }
        ._printChanges()
    }

    private func convert(group: ReminderGroupModel, myLists: IdentifiedArrayOf<ReminderMyListModel>) -> [Section] {
        switch group {
        case .all:
            return myLists.map { myList in
                Section(
                    name: myList.name,
                    subSections: [
                        SubSection(
                            name: nil,
                            reminders: myList.reminders)
                    ]
                )
            }
        case .today:
            return [Section(
                name: nil,
                subSections: [SubSection(
                    name: nil,
                    reminders: myLists
                        .flatMap(\.reminders)
                        .filter { $0.date.map(isToday) ?? false }
                        .toIdentifiedArray())
                ])
            ]
        case .hasDate:
            return []
        case .completed:
            return []
        }
    }

    private func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }

    private func reminderUpdatedEffect(id: ReminderModel.ID?, myLists: IdentifiedArrayOf<ReminderMyListModel>) -> Effect<Action> {
        if let id, let reminder = myLists.flatMap(\.reminders).first(where: \.id == id) {
            return .send(.internal(.reminderUpdated(reminder)))
        } else {
            return .none
        }
    }
}

//extension ReminderGroup.State {
//    static let mock: Self = .init(
//        group: .all,
//        myLists: .mock,
//        initial: nil,
//        focus: nil)
//}
