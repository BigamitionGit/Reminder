//
//  Reminder.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import ComposableArchitecture
import Foundation

@Reducer
public struct Reminder {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public let id: UUID
        public var title: String
        public var date: Date?
        public var isCompleted: Bool

        public init(id: UUID, title: String, date: Date?, isCompleted: Bool) {
            self.id = id
            self.title = title
            self.date = date
            self.isCompleted = isCompleted
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
    }

    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
    }
}
