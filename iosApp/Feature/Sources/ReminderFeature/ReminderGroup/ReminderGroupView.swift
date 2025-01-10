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
        ScrollView {
            LazyVStack {
                ForEach(store.scope(state: \.list, action: \.list)) { store in
                    ReminderView(store: store, focus: $focus)
                }
            }
        }
        .bind($store.focus, to: self.$focus)
        .navigationTitle(store.name)
        .toolbar {
            if focus != nil {
                ToolbarItem {
                    Button(String(localized: "reminder_edit_done", bundle: .module)) {
                        focus = nil
                    }
                }
            }
        }
    }
}
