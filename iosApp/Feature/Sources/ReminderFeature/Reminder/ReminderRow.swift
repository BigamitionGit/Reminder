//
//  ReminderView.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import SwiftUI
import ComposableArchitecture
import Helper
import Tagged
import Theme

public struct ReminderRow: View {
    @Binding private var reminder: ReminderModel
    private var focus: FocusState<ReminderModel.ID?>.Binding
    private let isNew: Bool

    public init(reminder: Binding<ReminderModel>, focus: FocusState<ReminderModel.ID?>.Binding, isNew: Bool = false) {
        self._reminder = reminder
        self.focus = focus
        self.isNew = isNew
    }

    public var body: some View {
        HStack(alignment: .top) {
            Toggle(isOn: $reminder.isCompleted) {
                if isNew {
                    Image(systemSymbol: .circleDotted)
                } else {
                    Image(systemSymbol: reminder.isCompleted ? .circleCircleFill : .circle)
                }
            }
            .toggleStyle(CheckToggleStyle())
            VStack(alignment: .leading) {
                TextField("", text: $reminder.title, axis: .vertical)
                    .foregroundColor(AssetColors.reminderRowTitle.swiftUIColor)
                    .focused(focus, equals: reminder.id)
                if let date = reminder.date {
                    Text(date, format: .numericShortened)
                }
            }
            Spacer()
            if focus.wrappedValue == reminder.id {
                Image(systemSymbol: .infoCircle)
            }
        }
        .background(AssetColors.reminderRowBackground.swiftUIColor)
    }
}

struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            configuration.label
                .foregroundStyle(
                    configuration.isOn ? Color.accentColor : .secondary
                )
                .imageScale(.large)
        }
        .buttonStyle(.plain)
    }
}

//#Preview {
//    ReminderGroupView(
//        store: .init(
//            initialState: .mock,
//            reducer: { ReminderGroup() }
//        )
//    )
//}
