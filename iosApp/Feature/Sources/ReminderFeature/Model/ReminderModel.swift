//
//  ReminderModel.swift
//  Feature
//
//  Created by 細田大志 on 2025/01/16.
//
import Tagged
import ComposableArchitecture
import Foundation
import Theme

public struct ReminderModel: Equatable, Identifiable, Codable {
    public let id: Tagged<Self, UUID>
    public let myListId: ReminderMyListModel.ID
    public var title: String
    public var date: Date?
    public var isCompleted: Bool
    public var isInvalid: Bool {
        title.isEmpty
    }
    public init(id: Tagged<Self, UUID>, myListId: ReminderMyListModel.ID, title: String = "", date: Date? = nil, isCompleted: Bool = false) {
        self.id = id
        self.myListId = myListId
        self.title = title
        self.date = date
        self.isCompleted = isCompleted
    }
}
