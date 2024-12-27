//
//  ReminderView.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import SwiftUI
import ComposableArchitecture

public struct ReminderView: View {
    @Bindable private var store: StoreOf<Reminder>

    public init(store: StoreOf<Reminder>) {
        self.store = store
    }

    public var body: some View {
        HStack {
            Toggle(isOn: $store.isCompleted) {
                Image(systemSymbol: store.isCompleted ? .circleCircleFill : .circle)
            }
        }
    }
}
