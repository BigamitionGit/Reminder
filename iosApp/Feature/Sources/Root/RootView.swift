//
//  RootView.swift
//
//
//  Created by 細田大志 on 2024/12/07.
//

import SwiftUI
import SharedKit
import ComposableArchitecture
import ReminderFeature
import Theme

public struct RootView: View {
    @Bindable private var store: StoreOf<Root>

    public init(store: StoreOf<Root>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(
            path: $store.scope(
                state: \.path,
                action: \.path
            )
        ) {
            ReminderTopView(
                store: store.scope(
                    state: \.reminderTop,
                    action: \.reminderTop))
        } destination: { store in
            switch store.case {
            case let .group(groupStore):
                ReminderGroupView(store: groupStore)
            case let .myList(myListStore):
                ReminderMyListView(store: myListStore)
            }
        }
    }
}

#Preview {
    RootView(
        store: .init(
            initialState: Root.State(),
            reducer: { Root() }
        )
    )
}
