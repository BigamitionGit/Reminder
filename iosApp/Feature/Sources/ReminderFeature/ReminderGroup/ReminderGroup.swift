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
    public struct State: Equatable, Identifiable {
        public let id: Tagged<Self, UUID>
        public var name: String
        public var icon: SFSymbol
        public var list: IdentifiedArrayOf<Reminder.State>
        public var initial: Reminder.State?
        public var focus: Reminder.State.ID?

        public init(id: Self.ID, name: String, icon: SFSymbol, list: IdentifiedArrayOf<Reminder.State>, initial: Reminder.State? = nil, focus: Reminder.State.ID? = nil) {
            self.id = id
            self.name = name
            self.icon = icon
            self.list = list
            self.initial = initial
            self.focus = focus
        }
    }

    public enum Action: BindableAction {
        case view(View)
        case delegate(Delegate)
        case `internal`(Internal)
        case addNew(Reminder.Action)
        case binding(BindingAction<State>)
        case list(IdentifiedActionOf<Reminder>)

        public enum View {
            case onAppear
            case editDone
        }

        public enum Delegate {
            case update(State.ID, IdentifiedArrayOf<Reminder.State>)
        }

        public enum Internal {
            case changefocus(Reminder.State.ID)
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
                state.initial = .init()
                return .none
            case let .internal(.changefocus(id)):
                if let new = state.initial, !new.isInvalid, id == new.id {
                    state.list.append(new)
                    state.initial = .init()
                }
                if let edit = state.list[id: id], edit.isInvalid {
                    state.list.remove(id: edit.id)
                }
                return .none
            case .view(.editDone):
                state.focus = nil
                return .none
            case .binding, .list, .addNew, .delegate:
                return .none
            }
        }
        .forEach(\.list, action: \.list) {
            Reminder()
        }
        .ifLet(\.initial, action: \.addNew) {
            Reminder()
        }
        .onChange(of: \.focus) { old, _ in
            Reduce { _, _ in
                changeFocusEffect(id: old)
            }
        }
        .onChange(of: \.list) { _, new in
            Reduce { state, _ in
                    .send(.delegate(.update(state.id, new)))
            }
        }
        ._printChanges()
    }

    private func changeFocusEffect(id: Reminder.State.ID?) -> Effect<Action> {
        if let id {
            return .send(.internal(.changefocus(id)))
        } else {
            return .none
        }
    }
}

extension ReminderGroup.State {
    static let mock: Self = ReminderGroup.State(
        id: .init(UUID()),
        name: "AAA",
        icon: .calendarCircleFill,
        list: [
            .init(id: .init(UUID()),
                  title: "111",
                  date: nil,
                  isCompleted: false),
            .init(id: .init(UUID()),
                  title: "222",
                  date: Date(),
                  isCompleted: true)])
}
