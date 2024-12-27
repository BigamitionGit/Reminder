//
//  SFSymbol.swift
//  Feature
//
//  Created by 細田大志 on 2024/12/27.
//
import SwiftUI
import UIKit

public enum SFSymbol: String {
    case chevronRight = "chevron.right"
    case circleCircleFill = "circle.circle.fill"
    case circle = "circle"
    case clockFill = "clock.fill"
    case calendarCircleFill = "calendar.circle.fill"
    case trayCircleFill = "tray.circle.fill"
    case checkmarkCircleFill = "checkmark.circle.fill"
}

public extension Image {
    init(systemSymbol: SFSymbol) {
        self.init(systemName: systemSymbol.rawValue)
    }
}

extension UIImage {
    convenience init?(systemSymbol: SFSymbol) {
        self.init(systemName: systemSymbol.rawValue)
    }
}
