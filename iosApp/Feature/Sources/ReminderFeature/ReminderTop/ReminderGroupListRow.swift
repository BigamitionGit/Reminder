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
    private var group: ReminderGroupModel

    public init(group: ReminderGroupModel) {
        self.group = group
    }

    public var body: some View {
        HStack {
            Image(systemSymbol: group.icon)
            Text(group.name)
            Spacer()
            Text("\(group.list.count)")
            Image(systemSymbol: .chevronRight)
        }
        .padding()
        .background(AssetColors.groupBackground.swiftUIColor)
    }
}
