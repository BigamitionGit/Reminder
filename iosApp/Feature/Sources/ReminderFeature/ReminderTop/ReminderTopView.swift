//
//  ReminderTopView.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import SwiftUI
import ComposableArchitecture
import Theme

public struct ReminderTopView: View {
    @Bindable private var store: StoreOf<ReminderTop>

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
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
            LazyVStack(spacing: 0) {
                ForEach(store.model.myLists, id: \.id) { myList in
                    Button {
                        store.send(.view(.myListTapped(myList.id)))
                    } label: {
                        ReminderMyListRow(myList: myList)
                    }
                    if store.model.myLists.last != myList {
                        Divider()
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .background(AssetColors.baseBackground.swiftUIColor)
    }
}

#Preview {
    ReminderTopView(
        store: .init(initialState: ReminderTop.State(groups: [.all, .hasDate, .today])) {
            ReminderTop()
        }
    )
}
