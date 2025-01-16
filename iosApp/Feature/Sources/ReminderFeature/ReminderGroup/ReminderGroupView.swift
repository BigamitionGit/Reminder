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
    @FocusState private var focus: ReminderModel.ID?

    public init(store: StoreOf<ReminderGroup>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            LazyVStack {
                ForEach($store.group.list, id: \.id) { $reminder in
                    ReminderRow(store: $reminder, focus: $focus)
                }
                if let initialReminder = Binding($store.initial) {
                    ReminderRow(store: initialReminder, focus: $focus, isNew: true)
                }
            }
            .bind($store.focus, to: self.$focus)
        }
        .navigationTitle(store.group.name)
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
