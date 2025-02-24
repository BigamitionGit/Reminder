//
//  ReminderMyListTests.swift
//  Feature
//
//  Created by 細田大志 on 2025/02/19.
//

import ComposableArchitecture
import Foundation
import Testing

@testable import ReminderFeature

@MainActor
struct ReminderMyListTests {

    @Test
    func addReminder() async throws {
        let myList = ReminderMyListModel.mock
        @Shared(.myLists) var myLists = ReminderMyListsModel(
            id: .init(),
            myLists: [myList]
        )
        var newReminder = ReminderModel(id: ReminderModel.ID(UUID(0)), myListId: myList.id, title: "")
        let initialState = try #require(ReminderMyList.State(myListId: myList.id, initial: newReminder, focus: newReminder.id))
        let store = TestStore(initialState: initialState) {
            ReminderMyList()
        } withDependencies: {
            $0.uuid = .incrementing
        }

        newReminder.title = "Release"
        await store.send(.binding(.set(\.initial, newReminder))) {
            $0.initial?.title = "Release"
        }

        await store.send(.view(.doneEditButtonTapped)) {
            $0.focus = nil
        }

        await store.receive(\.internal.changeFocus) {
            $0.$myList.withLock { _ = $0.reminders.append(newReminder) }
            $0.initial = ReminderModel(id: ReminderModel.ID(UUID(0)), myListId: myList.id)
        }
    }
}
