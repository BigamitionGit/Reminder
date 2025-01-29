//
//  ReminderMyListModel.swift
//  Feature
//
//  Created by 細田大志 on 2025/01/16.
//
import Tagged
import ComposableArchitecture
import Foundation
import Theme

public struct ReminderMyListModel: Equatable, Identifiable, Codable {
    public let id: Tagged<Self, UUID>
    public var name: String
    public var icon: SFSymbol
    public var reminders: IdentifiedArrayOf<ReminderModel>

    public init(id: Tagged<Self, UUID>, name: String, icon: SFSymbol, reminders: IdentifiedArrayOf<ReminderModel>) {
        self.id = id
        self.name = name
        self.icon = icon
        self.reminders = reminders
    }
}

extension SharedReaderKey where Self == FileStorageKey<IdentifiedArrayOf<ReminderMyListModel>>.Default {
  static var myLists: Self {
      Self[.fileStorage(URL.documentsDirectory.appending(component: "reminder-myLists.json")), default: .mock]
  }
}
