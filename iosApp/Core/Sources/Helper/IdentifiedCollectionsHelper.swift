//
//  File.swift
//  Core
//
//  Created by 細田大志 on 2024/12/27.
//

import ComposableArchitecture

extension Array where Element: Identifiable {
    public func toIdentifiedArray() -> IdentifiedArrayOf<Element> {
        IdentifiedArrayOf<Element>(uniqueElements: self)
    }
}
