//
//  ReminderGroupModel.swift
//  Feature
//
//  Created by 細田大志 on 2025/01/16.
//
import Tagged
import ComposableArchitecture
import Foundation
import Theme

public struct ReminderGroupModel: Equatable, Identifiable {
    public let id: Tagged<Self, UUID>
    public var name: String
    public var icon: SFSymbol
    public var list: IdentifiedArrayOf<ReminderModel>

    public init(id: Self.ID, name: String, icon: SFSymbol, list: IdentifiedArrayOf<ReminderModel>) {
        self.id = id
        self.name = name
        self.icon = icon
        self.list = list
    }
}
