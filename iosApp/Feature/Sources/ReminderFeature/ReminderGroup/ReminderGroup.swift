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
        @Shared(.myLists) var model
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
            case myListsUpdated(IdentifiedArrayOf<ReminderMyListModel>)
            case changeFocus(ReminderModel.ID)
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
            .onChange(of: \.focus) { old, _ in
                Reduce { _, _ in
                    changeFocusEffect(id: old)
                }
            }
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .publisher {
                    state.$model.myLists.publisher.map { Action.internal(.myListsUpdated($0)) }
                }
            case let .internal(.myListsUpdated(myLists)):
                state.sections = convert(group: state.group, myLists: myLists)
                return .none
            case let .internal(.changeFocus(id)):
                if let edit = state.model.myLists.flatMap(\.reminders).first(where: \.id == id), edit.isInvalid {
                    _ = state.$model.withLock { $0.myLists[id: edit.myListId]?.reminders.remove(id: edit.id) }
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
            Reduce { _, _ in
                changeFocusEffect(id: old)
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

    private func changeFocusEffect(id: ReminderModel.ID?) -> Effect<Action> {
        if let id {
            return .send(.internal(.changeFocus(id)))
        } else {
            return .none
        }
    }
}
