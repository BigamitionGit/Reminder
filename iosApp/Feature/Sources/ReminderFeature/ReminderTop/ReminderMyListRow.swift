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
                .foregroundColor(AssetColors.todayGroupThemeColor.swiftUIColor)
            Text(myList.name)
                .foregroundColor(AssetColors.myListRowName.swiftUIColor)
            Spacer()
            Text("\(myList.reminders.count)")
                .foregroundColor(AssetColors.myListRowCount.swiftUIColor)
            Image(systemSymbol: .chevronRight)
                .foregroundColor(AssetColors.myListRowArrow.swiftUIColor)
        }
        .padding()
        .background(AssetColors.myListRowBackGround.swiftUIColor)
    }
}
