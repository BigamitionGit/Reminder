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
                ForEach(store.filteredReminderGroups, id: \.id) { group in
                    Button {
                        store.send(.view(.groupTapped(group)))
                    } label: {
                        ReminderGroupGridRow(group: group)
                    }
                }
            }
            LazyVStack {
                ForEach(store.myLists, id: \.id) { myList in
                    Button {
                        store.send(.view(.myListTapped(myList)))
                    } label: {
                        ReminderGroupListRow(group: myList)
                    }
                }
            }
        }
    }
}

#Preview {
    ReminderTopView(
        store: .init(initialState: ReminderTop.State(myLists: .mock, filters: [.all, .hasDate, .today])) {
            ReminderTop()
        }
    )
}
