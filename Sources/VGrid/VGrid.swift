//
//  VGrid.swift
//  VGrid
//
//  Created by Elyes Derouiche on 16/09/2024.
//

import SwiftUI
import Foundation

/// A grid that displays a collection of data with configurable layout.
///
/// `VGrid` arranges data elements in a vertical grid with a customizable layout
/// using a `GridRowConfiguration` matrix that contains the size ratios for each cell
/// in the grid. The content of each cell is provided by a closure passed to the
/// `content` parameter. When the `isExpanded` binding is set to `true`, all
/// elements in the data collection will be displayed. Otherwise, only the first
/// `truncateAt` elements will be displayed. An optional closure passed to the
/// `expandedContent` parameter is displayed below the grid and can be used to
/// toggle the `isExpanded` binding. The `hSpacing` and `vSpacing` parameters can
/// be used to customize the horizontal and vertical spacing between cells.
///
/// Example usage:
///
/// ```swift
/// struct MyData: Identifiable, Hashable {
///     let id: UUID = UUID()
///     let name: String
/// }
///
/// let data = [
///     [MyData(name: "A"), MyData(name: "B"), MyData(name: "C")],
///     [MyData(name: "D"), MyData(name: "E"), MyData(name: "F")],
///     [MyData(name: "G"), MyData(name: "H"), MyData(name: "I")]
/// ]
///
/// let configuration: VGrid<MyData, Text, Empty>.GridConfiguration = [
///     [.fixed(ratio: 0.333), .fixed(ratio: 0.333), .fixed(ratio: 0.333)],
///     [.fixed(ratio: 0.4), .fixed(ratio: 0.4), .fixed(ratio: 0.2)],
///     [.fixed(ratio: 1)]
/// ]
///
/// var body: some View {
///     VGrid(data, configuration: configuration) { data in
///         Text(data.name)
///     }
/// }
/// ```
///
/// - Parameters:
///   - data: A collection of data elements to display in the grid.
///   - configuration: A matrix that defines the size ratios for each cell in the grid.
///   - vSpacing: The vertical spacing between cells in the grid.
///   - hSpacing: The horizontal spacing between cells in the grid. If `nil`, the spacing from the corresponding `GridRow` configuration is used.
///   - truncateAt: The maximum number of elements to display in the grid when `isExpanded` is `false`. Defaults to `nil`.
///   - isExpanded: A binding that controls whether all elements in `data` are displayed. Defaults to `true`.
///   - expandedContent: A closure that provides a view to display below the grid when `isExpanded` is `true`.
///   - content: A closure that provides a view for each data element in the grid.
public struct VGrid<
    Data,
    Content,
    ActionContent
>: View where Data: RandomAccessCollection, Content: View, ActionContent: View, Data.Element: RandomAccessCollection & Hashable, Data.Element.Element: Hashable
{
    // MARK: Public properties

    public typealias GridRowConfiguration = [[GridRow]]

    @Binding
    public var isExpanded: Bool

    @State
    private var contentHeight = CGFloat(100)

    @State
    private var isAnimationEnabled: Bool = false

    private let data: Data
    private let configuration: GridRowConfiguration
    private var truncateAt: Int? = 0

    private var containerAlignment: Alignment = .center
    private var contentHorizontalAlignment: HorizontalAlignment = .center

    private var vSpacing: CGFloat = 0.0
    private var hSpacing: CGFloat = 0.0
    private let content: (Data.Element.Element) -> Content
    private let expandedContent: () -> ActionContent

    // MARK: Initializer

    public init(
        _ data: Data,
        configuration: GridRowConfiguration,
        containerAlignment: Alignment = .center,
        contentHorizontalAlignment: HorizontalAlignment = .center,
        vSpacing: CGFloat = 5,
        hSpacing: CGFloat = 5,
        truncateAt: Int?,
        isExpanded: Binding<Bool>,
        @ViewBuilder expandedContent: @escaping () -> ActionContent,
        @ViewBuilder content: @escaping (Data.Element.Element) -> Content
    ) {
        self.configuration = configuration
        self.containerAlignment = containerAlignment
        self.contentHorizontalAlignment = contentHorizontalAlignment
        self.vSpacing = vSpacing
        self.hSpacing = hSpacing
        self.data = data
        self.truncateAt = truncateAt
        _isExpanded = isExpanded
        self.content = content
        self.expandedContent = expandedContent
    }

    // MARK: Body

    public var body: some View {
        GeometryReader { geo in
            VStack(alignment: contentHorizontalAlignment, spacing: vSpacing) {
                let filteredData = Array(data.prefix(isExpanded ? nil : truncateAt).enumerated())
                ForEach(filteredData, id: \.element) { rIndex, row in
                    HStack(spacing: hSpacing) {
                        ForEach(Array(row.enumerated()), id: \.element) { cIndex, item in
                            let configuration = getConfiguration(from: rIndex, y: cIndex)
                            content(item)
                                .frame(
                                    configuration: configuration,
                                    gMetrics: geo.size,
                                    rowItemsCount: row.count,
                                    spacing: hSpacing
                                )
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }

                if let truncateAt, data.count - 1 >= truncateAt {
                    expandedContent()
                }
            }
            .frame(
                width: geo.size.width,
                alignment: containerAlignment
            )
            .onSizeChanges(completion: { size in
                contentHeight = size.height
            })
        }
        .frame(height: contentHeight)
        .animation(.linear, value: isExpanded)
    }

    private func computeTrailing(hSpacing: CGFloat?, last: Bool) -> CGFloat {
        guard let hSpacing, last else { return 0 }
        return hSpacing
    }

    private func getConfiguration(from x: Int, y: Int) -> GridRow {
        guard x < configuration.count else {
            if y == 0 {
                return configuration.last?.first ?? .Default
            } else {
                return configuration.last?[safeIndex: y] ?? configuration.last?.last ?? GridRow.Default
            }
        }
        let row = configuration[x]
        guard y < row.count else {
            return row.last ?? GridRow.Default
        }
        return row[y]
    }
}

fileprivate extension View {
    @ViewBuilder
    func frame(
        configuration: GridRow,
        gMetrics: CGSize,
        rowItemsCount: Int,
        spacing: CGFloat = 0
    ) -> some View {
        switch configuration {
        case .fixed(let ratio, let height, let alignment):
            let computedWidth = ((gMetrics.width - ((spacing * CGFloat(rowItemsCount - 1)) - 0)) * ratio)
            if let height {
                frame(width: computedWidth, height: height, alignment: alignment ?? .center)
            } else {
                frame(width: computedWidth, alignment: alignment ?? .center)
                    .frame(maxHeight: .infinity, alignment: alignment ?? .center)
            }
        case .default:
            frame(width: nil, height: nil)
        }
    }
}

fileprivate extension Array {
    subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}

fileprivate extension RandomAccessCollection {
    func prefix(_ maxLength: Int?) -> SubSequence {
        if let maxLength {
            return self.prefix(maxLength)
        } else {
            return self.prefix(count)
        }
    }
}
