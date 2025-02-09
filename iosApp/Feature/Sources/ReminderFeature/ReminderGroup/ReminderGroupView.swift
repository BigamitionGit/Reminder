//
//  ReminderGroupView.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import SwiftUI
import ComposableArchitecture
import Theme

public struct ReminderGroupView: View {
    @Bindable private var store: StoreOf<ReminderGroup>
    @FocusState private var focus: ReminderModel.ID?

    public init(store: StoreOf<ReminderGroup>) {
        self.store = store
    }

    public var body: some View {
        List {
            ForEach($store.sections, id: \.id) { $section in
                if let sectionName = section.name {
                    Section(header: Text(sectionName)
                        .typography(.headline)
                        .foregroundColor(AssetColors.groupSectionName.swiftUIColor)) {
                        subSectionList(subSections: $section.subSections)
                        }.listSectionSeparator(.hidden)
                } else {
                    subSectionList(subSections: $section.subSections)
                }
            }
        }
        .listStyle(.plain)
        .bind($store.focus, to: self.$focus)
        .navigationTitle(store.group.name)
        .navigationBarTitleDisplayMode(.large)
        .onAppear { store.send(.view(.onAppear)) }
        .toolbar {
            if focus != nil {
                ToolbarItem {
                    Button(String(localized: "reminder_edit_done", bundle: .module)) {
                        store.send(.view(.editDone))
                    }
                }
            }
        }
    }

    private func subSectionList(subSections: Binding<[ReminderGroup.SubSection]>) -> some View {
        ForEach(subSections, id: \.id) { $subSection in
            if let subSectionName = subSection.name {
                Section(header: Text(subSectionName)
                    .typography(.subheadline)
                    .foregroundColor(AssetColors.groupSubSectionName.swiftUIColor)) {
                    reminderList(reminders: $subSection.reminders)
                }
                    .listSectionSeparator(.hidden)
            } else {
                reminderList(reminders: $subSection.reminders)
            }
        }
    }

    private func reminderList(reminders: Binding<IdentifiedArrayOf<ReminderModel>>) -> some View {
        ForEach(reminders, id: \.id) { $reminder in
            ReminderRow(reminder: $reminder, focus: $focus)
        }
    }
}

#Preview {
    @Shared(.myLists) var model = ReminderMyListsModel(id: .init(),
                                                       myLists: [.mock])
    NavigationStack {
        ReminderGroupView(store: .init(initialState: ReminderGroup.State(group: .hasDate), reducer: { ReminderGroup() }))
    }
}
