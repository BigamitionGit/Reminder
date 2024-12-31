//
//  ReminderView.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import SwiftUI
import ComposableArchitecture
import Helper

public struct ReminderView: View {
    @Bindable private var store: StoreOf<Reminder>

    public init(store: StoreOf<Reminder>) {
        self.store = store
    }

    public var body: some View {
        HStack(alignment: .top) {
            Toggle(isOn: $store.isCompleted) {
                Image(systemSymbol: store.isCompleted ? .circleCircleFill : .circle)
            }
            .toggleStyle(CheckToggleStyle())
            VStack(alignment: .leading) {
                Text(store.title)
                if let date = store.date {
                    Text(date, format: .numericShortened)
                }
            }
            Spacer()
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
