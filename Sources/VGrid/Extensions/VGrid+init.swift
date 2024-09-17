//
//  VGrid+init.swift
//  VGrid
//
//  Created by Elyes Derouiche on 16/09/2024.
//

import SwiftUI

extension VGrid where ActionContent == EmptyView {
    /// This initializer creates a VGrid view with the given data, configuration, vSpacing, hSpacing, and
    /// viewMode.
    /// This initializer omit the usage of `truncateAt` parameter which is set to nil.
    /// Finally, use the content parameter is a required parameter that is used to generate the content of
    /// each cell in the grid.
    public init(
        _ data: Data,
        configuration: GridRowConfiguration,
        containerAlignment: Alignment = .center,
        contentHorizontalAlignment: HorizontalAlignment = .center,
        vSpacing: CGFloat = 5,
        hSpacing: CGFloat = 5,
        @ViewBuilder content: @escaping (Data.Element.Element) -> Content
    ) {
        self.init(
            data,
            configuration: configuration,
            containerAlignment: containerAlignment,
            contentHorizontalAlignment: contentHorizontalAlignment,
            vSpacing: vSpacing,
            hSpacing: hSpacing,
            truncateAt: nil,
            isExpanded: .constant(true),
            expandedContent: { EmptyView() },
            content: content
        )
    }
}
