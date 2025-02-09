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
        @Shared public var myList: ReminderMyListModel
        public var initial: ReminderModel?
        public var focus: ReminderModel.ID?

        public init(myList: Shared<ReminderMyListModel>, initial: ReminderModel? = nil, focus: ReminderModel.ID? = nil) {
            self._myList = myList
            self.initial = initial
            self.focus = focus
        }

        public init?(myListId: ReminderMyListModel.ID, initial: ReminderModel? = nil, focus: ReminderModel.ID? = nil) {
            @Shared(.myLists) var myLists
            guard let my = Shared($myLists.myLists[id: myListId]) else { return nil }
            self._myList = my
            self.initial = initial
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
            case deleteReminders(IndexSet)
        }

        public enum Internal {
            case changeFocus(ReminderModel.ID)
        }
    }

    public init() {}

    @Dependency(\.uuid) var uuid
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
                return .none
            case let .internal(.changeFocus(id)):
                if let new = state.initial, !new.isInvalid, id == new.id {
                    _ = state.$myList.withLock { $0.reminders.append(new) }
                    state.initial = .init(id: .init(uuid()), myListId: state.myList.id)
                }
                if let edit = state.myList.reminders[id: id], edit.isInvalid {
                    _ = state.$myList.withLock { $0.reminders.remove(id: edit.id) }
                }
                return .none
            case .view(.editDone):
                state.focus = nil
                return .none
            case let .view(.deleteReminders(indices)):
                state.$myList.withLock { $0.reminders.remove(atOffsets: indices) }
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

    private func changeFocusEffect(id: ReminderModel.ID?) -> Effect<Action> {
        if let id {
            return .send(.internal(.changeFocus(id)))
        } else {
            return .none
        }
    }
}

extension ReminderMyList.State {
    private static let myListId = ReminderMyListModel.ID()
    static let mock: Self = .init(
        myList: Shared(
            value: .mock),
        initial: nil,
        focus: nil)
}
