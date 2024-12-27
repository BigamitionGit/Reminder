//
//  Root.swift
//
//
//  Created by 細田大志 on 2024/12/07.
//

import Foundation
import ComposableArchitecture
import Reminder
import Helper
import Theme

@Reducer
public struct Root {
    @Reducer(state: .equatable)
    public enum Path {
        case group(ReminderGroup)
    }
    @ObservableState
    public struct State {
        public var reminderTop: ReminderTop.State
        public var path = StackState<Path.State>()

        public init(reminderTop: ReminderTop.State = .init(), path: StackState<Path.State> = StackState<Path.State>()) {
            self.reminderTop = reminderTop
            self.path = path
        }
    }

    public enum Action {
        case reminderTop(ReminderTop.Action)
        case path(StackActionOf<Path>)
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.reminderTop, action: \.reminderTop) {
            ReminderTop()
        }
        navigationReducer
    }

    private var navigationReducer: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .reminderTop(.view(.groupTapped)):
                // TODO
                state.path.append(.group(.init(id: .init(), name: "", icon: .circle, list: [])))
                return .none
            case .path:
                return .none
            default:
                return .none
            }
        }
    }
}
