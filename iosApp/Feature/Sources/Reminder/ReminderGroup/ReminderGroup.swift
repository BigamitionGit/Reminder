//
//  ReminderGroup.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import ComposableArchitecture
import Theme
import Foundation

@Reducer
public struct ReminderGroup {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public let id: UUID
        public var name: String
        public var icon: SFSymbol
        public var list: IdentifiedArrayOf<Reminder.State>

        public init(id: UUID, name: String, icon: SFSymbol, list: IdentifiedArrayOf<Reminder.State>) {
            self.id = id
            self.name = name
            self.icon = icon
            self.list = list
        }
    }

    public enum Action: BindableAction {
        case view(View)
        case binding(BindingAction<State>)
        case list(IdentifiedActionOf<Reminder>)

        public enum View {
            case onAppear
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none
            case .binding:
                return .none
            case .list:
                return .none
            }
        }
        .forEach(\.list, action: \.list) {
            Reminder()
        }
    }
}
