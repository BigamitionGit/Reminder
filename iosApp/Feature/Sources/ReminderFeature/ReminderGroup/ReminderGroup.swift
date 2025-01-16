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
    @ObservableState
    public struct State: Equatable {
        public var group: ReminderGroupModel
        public var initial: ReminderModel?
        public var focus: ReminderModel.ID?

        public init(group: ReminderGroupModel, initial: ReminderModel? = .init(), focus: ReminderModel.ID? = nil) {
            self.group = group
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
            case update(ReminderGroupModel.ID, IdentifiedArrayOf<ReminderModel>)
        }

        public enum Internal {
            case changefocus(ReminderModel.ID)
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
            .onChange(of: \.group) { _, new in
                Reduce { state, _ in
                        .send(.delegate(.update(state.group.id, new.list)))
                }
            }
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                state.initial = .init()
                return .none
            case let .internal(.changefocus(id)):
                if let new = state.initial, !new.isInvalid, id == new.id {
                    state.group.list.append(new)
                    state.initial = .init()
                }
                if let edit = state.group.list[id: id], edit.isInvalid {
                    state.group.list.remove(id: edit.id)
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
        .onChange(of: \.group.list) { _, new in
            Reduce { state, _ in
                    .send(.delegate(.update(state.group.id, new)))
            }
        }
        ._printChanges()
    }

    private func changeFocusEffect(id: ReminderModel.ID?) -> Effect<Action> {
        if let id {
            return .send(.internal(.changefocus(id)))
        } else {
            return .none
        }
    }
}

extension ReminderGroup.State {
    static let mock: Self = .init(
        group: ReminderGroupModel(
            id: .init(),
            name: "AAA",
            icon: .calendarCircleFill,
            list: [
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
