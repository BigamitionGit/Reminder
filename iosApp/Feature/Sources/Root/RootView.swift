//
//  RootView.swift
//
//
//  Created by 細田大志 on 2024/12/07.
//

import SwiftUI
import SharedKit
import ComposableArchitecture
import Reminder
import Theme

public struct RootView: View {
    @Bindable private var store: StoreOf<Root>

    public init(store: StoreOf<Root>) {
        self.store = store
    }

    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
