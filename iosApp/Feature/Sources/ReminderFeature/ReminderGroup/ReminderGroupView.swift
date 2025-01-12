//
//  ReminderGroupView.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import SwiftUI
import ComposableArchitecture

public struct ReminderGroupView: View {
    @Bindable private var store: StoreOf<ReminderGroup>
    @FocusState private var focus: Reminder.State.ID?

    public init(store: StoreOf<ReminderGroup>) {
        self.store = store
    }

    public var body: some View {
        let _ = Self._printChanges()
        ScrollView {
            LazyVStack {
                ForEach(store.scope(state: \.list, action: \.list)) { reminderStore in
                    ReminderRow(store: reminderStore, focus: $focus)
                }
                if let reminderStore = store.scope(state: \.initial, action: \.addNew) {
                    ReminderRow(store: reminderStore, focus: $focus, isNew: true)
                }
            }
            .bind($store.focus, to: self.$focus)
        }
        .navigationTitle(store.name)
        .toolbar {
            if focus != nil {
                ToolbarItem {
                    Button(String(localized: "reminder_edit_done", bundle: .module)) {
                        store.send(.view(.editDone))
                    }
                }
            }
        }
    }
}
