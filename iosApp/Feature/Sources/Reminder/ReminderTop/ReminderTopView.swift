//
//  ReminderTopView.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import SwiftUI
import ComposableArchitecture

public struct ReminderTopView: View {
    @Bindable private var store: StoreOf<ReminderTop>

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    public init(store: StoreOf<ReminderTop>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(store.scope(state: \.filteredReminderGroups, action: \.groups)) { store in
                    ReminderGroupGridRow(store: store)
                }
            }
            LazyVStack {
                ForEach(store.scope(state: \.myGroups, action: \.groups)) { store in
                    ReminderGroupListRow(store: store)
                }
            }
        }
    }
}

#Preview {
    ReminderTopView(
        store: .init(initialState: ReminderTop.State(myGroups: .mock, filters: [.all, .hasDate, .today])) {
            ReminderTop()
        }
    )
}
