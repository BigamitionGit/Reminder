//
//  ReminderDetail.swift
//  Feature
//
//  Created by 細田大志 on 2025/02/09.
//

import Foundation
import ComposableArchitecture
import Helper

@Reducer
public struct ReminderDetail {
    @ObservableState
    public struct State: Equatable {
        public var reminder: ReminderModel
        public var isEditingDate: Bool
        public var isEditingTime: Bool
        public var shouldShowDatePicker: DatePickerComponent?
        public var editedReminder: ReminderModel {
            var editingReminder = reminder
            if isEditingDate {
                editingReminder.dueDate?.isYearMonthDayOnly = !isEditingTime
            } else {
                editingReminder.dueDate = nil
            }
            return editingReminder
        }

        public init(reminder: ReminderModel, shouldShowDatePicker: DatePickerComponent? = nil) {
            self.reminder = reminder
            self.shouldShowDatePicker = shouldShowDatePicker
            self.isEditingDate = reminder.dueDate != nil
            self.isEditingTime = reminder.dueDate.map(!\.isYearMonthDayOnly) ?? false
        }
    }
    public enum DatePickerComponent {
        case date
        case time
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case view(View)

        public enum View {
            case dateRowTapped
            case timeRowTapped
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.isEditingDate):
                if state.isEditingDate {
                    state.reminder.dueDate = .init(date: Date(),
                                                   isYearMonthDayOnly: true)
                    state.shouldShowDatePicker = .date
                } else {
                    state.shouldShowDatePicker = nil
                    state.isEditingTime = false
                }
                return .none
            case .binding(\.isEditingTime):
                if state.isEditingTime {
                    state.reminder.dueDate = .init(date: Date(),
                                                   isYearMonthDayOnly: false)
                    state.isEditingDate = true
                    state.shouldShowDatePicker = .time
                } else {
                    if state.shouldShowDatePicker == .time {
                        state.shouldShowDatePicker = nil
                    }
                }
                return .none
            case .view(.dateRowTapped):
                if state.shouldShowDatePicker == .date {
                    state.shouldShowDatePicker = nil
                } else {
                    state.shouldShowDatePicker = .date
                }
                return .none
            case .view(.timeRowTapped):
                if state.shouldShowDatePicker == .time {
                    state.shouldShowDatePicker = nil
                } else {
                    state.shouldShowDatePicker = .time
                }
                return .none
            case .binding:
                return .none
            }
        }
    }
}
