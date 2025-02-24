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
    @Reducer(state: .equatable)
    public enum Destination {
        case add(ReminderDetail)
    }
    @ObservableState
    public struct State: Equatable {
        @Shared public var myList: ReminderMyListModel
        public var initial: ReminderModel?
        public var focus: ReminderModel.ID?
        @Presents public var destination: Destination.State?

        public init?(myListId: ReminderMyListModel.ID, initial: ReminderModel? = nil, focus: ReminderModel.ID? = nil, destination: Destination.State? = nil) {
            @Shared(.myLists) var myLists
            guard let my = Shared($myLists.myLists[id: myListId]) else { return nil }
            self._myList = my
            self.initial = initial
            self.focus = focus
            self.destination = destination
        }
    }

    public enum Action: BindableAction {
        case view(View)
        case `internal`(Internal)
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)

        public enum View {
            case onAppear
            case doneEditButtonTapped
            case deleteReminders(IndexSet)
            case infoTapped(ReminderModel)
            case doneDetailEditButtonTapped
            case cancelDetailEditButtonTapped
        }

        @CasePathable
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
            case .view(.doneEditButtonTapped):
                state.focus = nil
                return .none
            case let .view(.deleteReminders(indices)):
                state.$myList.withLock { $0.reminders.remove(atOffsets: indices) }
                return .none
            case let .view(.infoTapped(reminder)):
                state.destination = .add(ReminderDetail.State(reminder: reminder))
                return .none
            case .view(.doneDetailEditButtonTapped):
                guard case let .some(.add(detailState)) = state.destination else { return .none }
                if let new = state.initial, new.id == detailState.editedReminder.id {
                    _ = state.$myList.withLock { $0.reminders.append(detailState.reminder) }
                    state.initial = .init(id: .init(uuid()), myListId: state.myList.id)
                } else {
                    state.$myList.withLock { $0.reminders[id: detailState.reminder.id] = detailState.reminder }
                }
                state.destination = nil
                return .none
            case .view(.cancelDetailEditButtonTapped):
                state.destination = nil
                return .none
            case .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
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
