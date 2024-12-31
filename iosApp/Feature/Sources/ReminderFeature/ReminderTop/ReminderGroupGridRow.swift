//
//  ReminderGroupGridRow.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import SwiftUI
import ComposableArchitecture
import Theme

public struct ReminderGroupGridRow: View {
    @Bindable private var store: StoreOf<ReminderGroup>

    public init(store: StoreOf<ReminderGroup>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(AssetColors.groupBackground.swiftUIColor)
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemSymbol: store.icon)
                    Spacer()
                    Text("\(store.list.count)")
                }
                Text(store.name)
                    .foregroundColor(Color.blue)
            }
            .padding()
        }
    }
}
