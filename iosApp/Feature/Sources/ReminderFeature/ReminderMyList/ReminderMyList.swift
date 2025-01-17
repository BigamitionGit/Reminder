//
//  ReminderMyList.swift
//  Feature
//
//  Created by 細田大志 on 2025/01/17.
//
import ComposableArchitecture
import Theme
import Foundation
import Helper
import Tagged

@Reducer
public struct ReminderMyList {
    @ObservableState
    public struct State: Equatable {
        public var myList: ReminderMyListModel
        public var initial: ReminderModel?
        public var focus: ReminderModel.ID?

        public init(myList: ReminderMyListModel, initial: ReminderModel? = .init(), focus: ReminderModel.ID? = nil) {
            self.myList = myList
            self.initial = initial
            self.focus = focus
        }
    }

    public enum Action: BindableAction {
        case view(View)
        case delegate(Delegate)
        case `internal`(Internal)
        case binding(BindingAction<State>)

        public enum View {
            case onAppear
            case editDone
        }

        public enum Delegate {
            case update(ReminderMyListModel.ID, IdentifiedArrayOf<ReminderModel>)
        }

        public enum Internal {
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
            .onChange(of: \.myList) { _, new in
                Reduce { state, _ in
                        .send(.delegate(.update(state.myList.id, new.reminders)))
                }
            }
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none
            case let .internal(.changeFocus(id)):
                if let new = state.initial, !new.isInvalid, id == new.id {
                    state.myList.reminders.append(new)
                    state.initial = .init()
                }
                if let edit = state.myList.reminders[id: id], edit.isInvalid {
                    state.myList.reminders.remove(id: edit.id)
                }
                return .none
            case .view(.editDone):
                state.focus = nil
                return .none
            case .binding, .delegate:
                return .none
            }
        }
        .onChange(of: \.focus) { old, _ in
            Reduce { _, _ in
                changeFocusEffect(id: old)
            }
        }
        .onChange(of: \.myList.reminders) { _, new in
            Reduce { state, _ in
                    .send(.delegate(.update(state.myList.id, new)))
            }
        }
        ._printChanges()
    }

    private func changeFocusEffect(id: ReminderModel.ID?) -> Effect<Action> {
        if let id {
            return .send(.internal(.changeFocus(id)))
        } else {
            return .none
        }
    }
}

extension ReminderMyList.State {
    static let mock: Self = .init(
        myList: ReminderMyListModel(
            id: .init(),
            name: "AAA",
            icon: .calendarCircleFill,
            reminders: [
                .init(
                    id: .init(),
                    title: "111",
                    isCompleted: false),
                .init(
                    id: .init(),
                    title: "222",
                    isCompleted: true)
            ]),
        initial: nil,
        focus: nil)
}
