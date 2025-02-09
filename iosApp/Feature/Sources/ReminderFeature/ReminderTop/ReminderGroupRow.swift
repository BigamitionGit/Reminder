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
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemSymbol: group.icon)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(group.themeColor().swiftUIColor)
                    Spacer()
                    Text("\(reminderCount)")
                        .typography(.largeTitle)
                        .foregroundColor(AssetColors.groupRowCount.swiftUIColor)
                }
                Text(group.name)
                    .typography(.body3)
                    .foregroundColor(AssetColors.groupRowName.swiftUIColor)
            }
            .padding()
        }
        .foregroundColor(AssetColors.groupRowBackground.swiftUIColor)
    }
}

#Preview {
    ReminderGroupRow(
        group: .all,
        reminderCount: 3)
    .frame(width: 160, height: 40)
}
