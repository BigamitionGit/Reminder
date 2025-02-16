//
//  ReminderMyListView.swift
//  Feature
//
//  Created by 細田大志 on 2025/01/17.
//
import SwiftUI
import ComposableArchitecture
import Theme

public struct ReminderMyListView: View {
    @Bindable private var store: StoreOf<ReminderMyList>
    @FocusState private var focus: ReminderModel.ID?

    public init(store: StoreOf<ReminderMyList>) {
        self.store = store
    }

    public var body: some View {
        List {
            ForEach($store.myList.reminders, id: \.id) { $reminder in
                ReminderRow(reminder: $reminder, focus: $focus) {
                    store.send(.view(.infoTapped(reminder)))
                }
            }
            .onDelete { indices in
                store.send(.view(.deleteReminders(indices)))
            }
            if let initialReminder = Binding($store.initial) {
                ReminderRow(reminder: initialReminder, focus: $focus, isNew: true) {
                    store.send(.view(.infoTapped(initialReminder.wrappedValue)))
                }
            }
        }
        .bind($store.focus, to: self.$focus)
        .listStyle(.plain)
        .navigationTitle(store.myList.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if focus != nil {
                ToolbarItem {
                    Button(String(localized: "reminder_edit_done", bundle: .module)) {
                        store.send(.view(.doneEditButtonTapped))
                    }
                }
            }
        }
        .sheet(item: $store.scope(state: \.destination?.add, action: \.destination.add)) { detailStore in
            NavigationStack {
                ReminderDetailView(store: detailStore)
                    .navigationTitle(String(localized: "reminder_details", bundle: .module))
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(String(localized: "reminder_details_cancel", bundle: .module)) {
                                store.send(.view(.cancelDetailEditButtonTapped))
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button(String(localized: "reminder_details_done", bundle: .module)) {
                                store.send(.view(.doneDetailEditButtonTapped))
                            }
                        }
                    }
            }
        }
    }
}
