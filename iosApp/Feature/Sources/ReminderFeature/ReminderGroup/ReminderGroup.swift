//
//  ReminderGroup.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import ComposableArchitecture
import Theme
import Foundation
import Helper
import Tagged

@Reducer
public struct ReminderGroup {

    public struct Section: Equatable, Identifiable {
        public let id: Tagged<Self, UUID> = .init()
        public let name: String?
        public var subSections: [SubSection]
    }
    public struct SubSection: Equatable, Identifiable {
        public let id: Tagged<Self, UUID> = .init()
        public let name: String?
        public var reminders: IdentifiedArrayOf<ReminderModel>
    }

    @ObservableState
    public struct State: Equatable {
        public let group: ReminderGroupModel
        @Shared(.myLists) var model
        public var focus: ReminderModel.ID?
        public var sections: [Section] = []

        public init(group: ReminderGroupModel, focus: ReminderModel.ID? = nil) {
            self.group = group
            self.focus = focus
        }
    }

    public enum Action: BindableAction {
        case view(View)
        case `internal`(Internal)
        case binding(BindingAction<State>)

        public enum View {
            case onAppear
            case editDone
        }

        public enum Internal {
            case myListsUpdated(IdentifiedArrayOf<ReminderMyListModel>)
            case changeFocus(ReminderModel.ID)
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
            .onChange(of: \.focus) { old, _ in
                Reduce { _, _ in
                    changeFocusEffect(id: old)
                }
            }
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .publisher {
                    state.$model.myLists.publisher.map { Action.internal(.myListsUpdated($0)) }
                }
            case let .internal(.myListsUpdated(myLists)):
                state.sections = convert(group: state.group, myLists: myLists)
                return .none
            case let .internal(.changeFocus(id)):
                if let edit = state.model.myLists.flatMap(\.reminders).first(where: \.id == id), edit.isInvalid {
                    _ = state.$model.withLock { $0.myLists[id: edit.myListId]?.reminders.remove(id: edit.id) }
                }
                return .none
            case .view(.editDone):
                state.focus = nil
                return .none
            case .binding:
                return .none
            }
        }
        .onChange(of: \.focus) { old, _ in
            Reduce { _, _ in
                changeFocusEffect(id: old)
            }
        }
        ._printChanges()
    }

    private func convert(group: ReminderGroupModel, myLists: IdentifiedArrayOf<ReminderMyListModel>) -> [Section] {
        switch group {
        case .all:
            return myLists.map { myList in
                Section(
                    name: myList.name,
                    subSections: [
                        SubSection(
                            name: nil,
                            reminders: myList.reminders
                                .filter(!\.isCompleted))
                    ]
                )
            }
        case .today:
            return [Section(
                name: nil,
                subSections: [SubSection(
                    name: nil,
                    reminders: myLists
                        .flatMap(\.reminders)
                        .filter(!\.isCompleted)
                        .filter(\.isToday)
                        .toIdentifiedArray())
                ])
            ]
        case .hasDate:
            let scheduledReminders = myLists
                .flatMap(\.reminders)
                .filter(!\.isCompleted)
                .filter(\.date != nil)
            let subSectionDateFormat = Date.FormatStyle.dateTime.year().month().weekday().day()
            func updateSuSections(subSections: inout [SubSection], reminder: ReminderModel) {
                guard let date = reminder.date else { return }
                let name = date.formatted(subSectionDateFormat)
                if let index = subSections.firstIndex(where: \.name == name) {
                    subSections[index].reminders.append(reminder)
                } else {
                    subSections.append(SubSection(name: name, reminders: [reminder]))
                }
            }
            let pastDueReminders = scheduledReminders.filter(\.isPastDue)
            let pastDueSection = Section(name: String(localized: "reminder_group_pastDue", bundle: .module),
                                         subSections: pastDueReminders.reduce(into: [SubSection](), updateSuSections))
            let todayReminders = scheduledReminders.filter(\.isToday)
            let todaySection = Section(
                name: String(localized: "reminder_group_today", bundle: .module),
                subSections: [SubSection(
                    name: nil,
                    reminders: todayReminders.toIdentifiedArray())])
            let calendar = Calendar.current
            let next12MonthsSection = calendar.getMonths(
                from: Date(),
                range: 0..<12)
                .map { month in
                    let monthReminders = scheduledReminders.filter { reminder in
                        guard let date = reminder.date else { return false }
                        return calendar.isSameMonth(date1: date, date2: month)
                    }
                    return Section(name: month.formatted(.dateTime.month()),
                            subSections: monthReminders.reduce(into: [SubSection](), updateSuSections))
                }
            return [pastDueSection] + [todaySection] + next12MonthsSection
        case .completed:
            return [Section(
                name: nil,
                subSections: [SubSection(
                    name: nil,
                    reminders: myLists
                        .flatMap(\.reminders)
                        .filter(\.isCompleted)
                        .toIdentifiedArray())
                ])
            ]
        }
    }

    private func changeFocusEffect(id: ReminderModel.ID?) -> Effect<Action> {
        if let id {
            return .send(.internal(.changeFocus(id)))
        } else {
            return .none
        }
    }
}
