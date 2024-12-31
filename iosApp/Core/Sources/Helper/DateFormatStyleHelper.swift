//
//  DateFormatStyleHelper.swift
//  Core
//
//  Created by 細田大志 on 2024/12/29.
//
import Foundation

public extension FormatStyle where Self == NumericShortenedFormatStyle {

    static var numericShortened: NumericShortenedFormatStyle { return NumericShortenedFormatStyle() }

}

public struct NumericShortenedFormatStyle: FormatStyle {
    public typealias FormatInput = Date
    public typealias FormatOutput = String

    private static let customFormatStyle = Date.FormatStyle(
        date: .numeric,
        time: .shortened,
        locale: Locale(identifier: "ja_JP"),
        calendar: Calendar(identifier: .gregorian))

    public func format(_ value: Date) -> String {
        return Self.customFormatStyle.format(value)
    }

}
