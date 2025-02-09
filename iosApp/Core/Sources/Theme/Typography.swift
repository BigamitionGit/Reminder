//
//  TextStyle.swift
//  Core
//
//  Created by 細田大志 on 2025/02/06.
//
import SwiftUI

public struct Typography: Sendable {
    let textStyle: Font.TextStyle
    let weight: Font.Weight
    let width: Font.Width
    let leading: Font.Leading

    public static let body1 = Typography(
        textStyle: .body,
        weight: .regular,
        width: .standard,
        leading: .standard)
    public static let body2 = Typography(
        textStyle: .body,
        weight: .regular,
        width: .condensed,
        leading: .standard)
    public static let body3 = Typography(
        textStyle: .body,
        weight: .bold,
        width: .expanded,
        leading: .standard)
    public static let headline = Typography(
        textStyle: .title2,
        weight: .semibold,
        width: .condensed,
        leading: .standard)
    public static let subheadline = Typography(
        textStyle: .subheadline,
        weight: .regular,
        width: .standard,
        leading: .standard)
    public static let largeTitle = Typography(
        textStyle: .largeTitle,
        weight: .bold,
        width: .standard,
        leading: .standard)
}

public extension View {
    func typography(_ typography: Typography) -> some View {
        self.modifier(TypographyModifier(typography: typography))
    }
}

private struct TypographyModifier: ViewModifier {
    var typography: Typography
    func body(content: Content) -> some View {
        content
            .font(.system(
                typography.textStyle,
                weight: typography.weight
            )
                .leading(typography.leading)
            )
            .fontWidth(typography.width)
    }
}
