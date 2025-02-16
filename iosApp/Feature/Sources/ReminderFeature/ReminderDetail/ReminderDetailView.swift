//
//  ReminderDetailView.swift
//  Feature
//
//  Created by 細田大志 on 2025/02/09.
//

import SwiftUI
import ComposableArchitecture
import Theme
import Helper

public struct ReminderDetailView: View {
    @Bindable private var store: StoreOf<ReminderDetail>

    public init(store: StoreOf<ReminderDetail>) {
        self.store = store
    }

    public var body: some View {
        Form {
            Section {
                TextField(String(localized: "reminder_details_title", bundle: .module), text: $store.reminder.title)
                    .typography(.body2)
                    .foregroundColor(AssetColors.reminderDetailSectionTitle.swiftUIColor)
                    .background(AssetColors.reminderDetailSectionBackground.swiftUIColor)
                    .padding(.vertical, 4)
            }

            Section {
                Toggle(isOn: $store.isEditingDate) {
                    HStack {
                        Image(systemSymbol: .calendar)
                        Text(String(localized: "reminder_details_date", bundle: .module))
                            .typography(.body2)
                            .foregroundColor(AssetColors.reminderDetailSectionTitle.swiftUIColor)
                    }
                }
                .label(store.isEditingDate ? { store.send(.view(.dateRowTapped)) } : nil)
                .background(AssetColors.reminderDetailSectionBackground.swiftUIColor)

                if let dueDate = Binding($store.reminder.dueDate), store.shouldShowDatePicker == .date {
                    DatePicker("",
                               selection: dueDate.date,
                               displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .background(AssetColors.reminderDetailSectionBackground.swiftUIColor)
                }

                Toggle(isOn: $store.isEditingTime) {
                    HStack {
                        Image(systemSymbol: .clockFill)
                        Text(String(localized: "reminder_details_time", bundle: .module))
                            .foregroundColor(AssetColors.reminderDetailSectionTitle.swiftUIColor)
                    }
                }
                .label(store.isEditingTime ? { store.send(.view(.timeRowTapped)) } : nil)
                .background(AssetColors.reminderDetailSectionBackground.swiftUIColor)

                if let dueDate = Binding($store.reminder.dueDate), store.shouldShowDatePicker == .time {
                    DatePicker("",
                                                   selection: dueDate.date,
                                                   displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .background(AssetColors.reminderDetailSectionBackground.swiftUIColor)
                }
            }
        }
    }
}

extension Toggle {
    func label(_ action: (() -> Void)?) -> some View {
        self.modifier(ToggleLabelModifier(action: action))
    }
}

private struct ToggleLabelModifier: ViewModifier {
    var action: (() -> Void)?
    func body(content: Content) -> some View {
        if let action {
            Button {
                action()
            } label: {
                content
            }
        } else {
            content
        }
    }
}

#Preview {
    ReminderDetailView(
        store: .init(
            initialState: ReminderDetail.State(
                reminder: .init(
                    id: .init(),
                    myListId: .init(),
                    title: "111",
                    dueDate: Calendar.current.createDate(
                        year: 2024,
                        month: 12,
                        day: 1
                    ).map { .init(
                        date: $0,
                        isYearMonthDayOnly: false
                    ) },
                    isCompleted: false
                )
            ),
            reducer: { ReminderDetail() }
        )
    )
}
