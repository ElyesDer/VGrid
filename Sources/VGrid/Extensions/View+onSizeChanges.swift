//
//  View+onSizeChanges.swift
//  VGrid
//
//  Created by Elyes Derouiche on 16/09/2024.
//

import SwiftUI

// MARK: - View + onSizeChanges

public extension View {
    /// Simplify the observation of the View's size using it's parent's coordinate space
    /// Usage:
    ///
    ///     var body: some View {
    ///         MyView()
    ///             .onSizeChanges { cgSize in
    ///                 // compute with new Size
    ///             }
    ///     }
    /// - Parameters:
    ///   - completion: Fires on View's intrinsic size changes and returns a `CGSize`
    func onSizeChanges(completion: @escaping (CGSize) -> Void) -> some View {
        modifier(SizeModifier())
            .onPreferenceChange(SizePreferenceKey.self) {
                completion($0)
            }
    }

    /// Captures the size of a view and updates a `Binding` parameter with the new value.
    /// - Parameter size: A `Binding` of `CGSize` to be updated with the size of the view.
    /// - Returns: A modified version of the view with `GeometryReader` to capture its size.
    func onSizeChanges(_ size: Binding<CGSize>) -> some View {
        modifier(SizeModifier())
            .onPreferenceChange(SizePreferenceKey.self) { value in
                size.wrappedValue = value
            }
    }
}

// MARK: - SizePreferenceKey View Size Observer

struct SizePreferenceKey: PreferenceKey {
    public static let defaultValue: CGSize = .zero
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

// MARK: - SizeModifier Implementation

/// Size Modifier that adds a `GeometryReader` to a View to evaluate it's Content Intrinsic Size
/// Usage:
///
///     var body: some View {
///         MyView()
///             .modifier(SizeModifier())
///             .onPreferenceChange(SizePreferenceKey.self) { cgSize in
///                 // compute with new Size
///             }
///     }
struct SizeModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.overlay(
            GeometryReader { geo in
                Color.clear.preference(
                    key: SizePreferenceKey.self,
                    value: geo.size
                )
            }
        )
    }
}
