//
//  ReminderGroupGridRow.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import SwiftUI
import ComposableArchitecture
import Theme

public struct ReminderGroupRow: View {
    private var group: ReminderGroupModel
    private var reminderCount: Int

    public init(group: ReminderGroupModel, reminderCount: Int) {
        self.group = group
        self.reminderCount = reminderCount
    }

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(AssetColors.groupRowBackground.swiftUIColor)
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemSymbol: group.icon)
                        .foregroundColor(group.themeColor().swiftUIColor)
                    Spacer()
                    Text("\(reminderCount)")
                        .foregroundColor(AssetColors.groupRowCount.swiftUIColor)
                }
                Text(group.name)
                    .foregroundColor(AssetColors.groupRowName.swiftUIColor)
            }
            .padding()
        }
    }
}
