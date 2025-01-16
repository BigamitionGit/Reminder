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
    private var group: ReminderGroupModel

    public init(group: ReminderGroupModel) {
        self.group = group
    }

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(AssetColors.groupBackground.swiftUIColor)
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemSymbol: group.icon)
                    Spacer()
                    Text("\(group.list.count)")
                }
                Text(group.name)
                    .foregroundColor(Color.blue)
            }
            .padding()
        }
    }
}
