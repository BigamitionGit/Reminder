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
            Text(myList.name)
            Spacer()
            Text("\(myList.reminders.count)")
            Image(systemSymbol: .chevronRight)
        }
        .padding()
        .background(AssetColors.groupBackground.swiftUIColor)
    }
}
