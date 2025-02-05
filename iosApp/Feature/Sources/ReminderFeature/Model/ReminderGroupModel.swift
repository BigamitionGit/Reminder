//
//  ReminderGroupModel.swift
//  Feature
//
//  Created by 細田大志 on 2025/01/17.
//
import Tagged
import ComposableArchitecture
import Foundation
import Theme


public enum ReminderGroupModel: Equatable, Identifiable {
    case today
    case hasDate
    case all
    case completed

    public var id: Self {
        return self
    }

    public var name: String {
        switch self {
        case .today:
            String(localized: "reminder_group_today", bundle: .module)
        case .hasDate:
            String(localized: "reminder_group_hasDate", bundle: .module)
        case .all:
            String(localized: "reminder_group_all", bundle: .module)
        case .completed:
            String(localized: "reminder_group_completed", bundle: .module)
        }
    }
    public var icon: SFSymbol {
        switch self {
        case .today:
                .clockFill
        case .hasDate:
                .calendarCircleFill
        case .all:
                .trayCircleFill
        case .completed:
                .checkmarkCircleFill
        }
    }

    public func themeColor() -> ColorAsset {
        switch self {
        case .today:
            AssetColors.todayGroupThemeColor
        case .hasDate:
            AssetColors.scheduledGroupThemeColor
        case .all:
            AssetColors.allGroupThemeColor
        case .completed:
            AssetColors.completedGroupThemeColor
        }
    }
}
