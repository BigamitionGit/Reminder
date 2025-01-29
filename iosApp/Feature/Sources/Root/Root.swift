//
//  Root.swift
//
//
//  Created by 細田大志 on 2024/12/07.
//

import Foundation
import ComposableArchitecture
import ReminderFeature
import Helper
import Theme

@Reducer
public struct Root {
    @Reducer(state: .equatable)
    public enum Path {
        case group(ReminderGroup)
        case myList(ReminderMyList)
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

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.reminderTop, action: \.reminderTop) {
            ReminderTop()
        }
        navigationReducer
    }

    @Dependency(\.uuid) var uuid
    private var navigationReducer: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .reminderTop(.view(.groupTapped(let group))):
                state.path.append(.group(.init(group: group)))
                return .none
            case .reminderTop(.view(.myListTapped(let myListId))):
                if let myList = Shared(state.reminderTop.$myLists[id: myListId]) {
                    state.path.append(.myList(.init(
                        myList: myList,
                        initial: .init(
                            id: .init(uuid()),
                            myListId: myListId))))
                }
                return .none
            case .path:
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
