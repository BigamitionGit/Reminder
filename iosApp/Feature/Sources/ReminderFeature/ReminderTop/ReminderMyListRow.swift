//
//  ReminderGroupListRow.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import SwiftUI
import ComposableArchitecture
import Theme

public struct ReminderMyListRow: View {
    private var myList: ReminderMyListModel

    public init(myList: ReminderMyListModel) {
        self.myList = myList
    }

    public var body: some View {
        HStack {
            Image(systemSymbol: myList.icon)
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(AssetColors.todayGroupThemeColor.swiftUIColor)
            Text(myList.name)
                .typography(.body1)
                .foregroundColor(AssetColors.myListRowName.swiftUIColor)
            Spacer()
            Text("\(myList.reminders.count)")
                .typography(.subheadline)
                .foregroundColor(AssetColors.myListRowCount.swiftUIColor)
            Image(systemSymbol: .chevronRight)
                .foregroundColor(AssetColors.myListRowArrow.swiftUIColor)
        }
        .padding()
        .background(AssetColors.myListRowBackGround.swiftUIColor)
    }
}

#Preview {
    ReminderMyListRow(myList: .mock)
}
