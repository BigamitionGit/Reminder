//
//  ReminderGroupListRow.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import SwiftUI
import ComposableArchitecture
import Theme

public struct ReminderGroupListRow: View {
    @Bindable private var store: StoreOf<ReminderGroup>

    public init(store: StoreOf<ReminderGroup>) {
        self.store = store
    }

    public var body: some View {
        HStack {
            Image(systemSymbol: store.icon)
            Text(store.name)
            Spacer()
            Text("\(store.list.count)")
            Image(systemSymbol: .chevronRight)
        }
        .padding()
        .background(AssetColors.groupBackground.swiftUIColor)
    }
}
