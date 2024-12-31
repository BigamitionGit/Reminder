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

    public init(store: StoreOf<ReminderGroup>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(store.scope(state: \.list, action: \.list)) { store in
                    ReminderView(store: store)
                }
            }
        }
        .navigationTitle(store.name)
    }
}
