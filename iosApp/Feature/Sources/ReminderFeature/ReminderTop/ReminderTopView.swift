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
                ForEach(store.groupsWithCount, id: \.0) { group, count in
                    Button {
                        store.send(.view(.groupTapped(group)))
                    } label: {
                        ReminderGroupRow(group: group, reminderCount: count)
                    }
                }
            }
            LazyVStack {
                ForEach(store.model.myLists, id: \.id) { myList in
                    Button {
                        store.send(.view(.myListTapped(myList.id)))
                    } label: {
                        ReminderMyListRow(myList: myList)
                    }
                }
            }
        }
    }
}

#Preview {
    ReminderTopView(
        store: .init(initialState: ReminderTop.State(groups: [.all, .hasDate, .today])) {
            ReminderTop()
        }
    )
}
