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
    @Binding private var store: ReminderModel
    private var focus: FocusState<ReminderModel.ID?>.Binding
    private let isNew: Bool

    public init(store: Binding<ReminderModel>, focus: FocusState<ReminderModel.ID?>.Binding, isNew: Bool = false) {
        self._store = store
        self.focus = focus
        self.isNew = isNew
    }

    public var body: some View {
        HStack(alignment: .top) {
            Toggle(isOn: $store.isCompleted) {
                if isNew {
                    Image(systemSymbol: .circleDotted)
                } else {
                    Image(systemSymbol: store.isCompleted ? .circleCircleFill : .circle)
                }
            }
            .toggleStyle(CheckToggleStyle())
            VStack(alignment: .leading) {
                TextEditor(text: $store.title)
                    .focused(focus, equals: store.id)
                if let date = store.date {
                    Text(date, format: .numericShortened)
                }
            }
            Spacer()
            if focus.wrappedValue == store.id {
                Image(systemSymbol: .infoCircle)
            }
        }
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

#Preview {
    ReminderGroupView(
        store: .init(
            initialState: .mock,
            reducer: { ReminderGroup() }
        )
    )
}
