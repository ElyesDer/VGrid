
# VGrid SwiftUI Component

`VGrid` is a customizable vertical grid component for SwiftUI that allows you to display a collection of data with a configurable layout. It provides a flexible way to arrange items in a grid using a matrix of size ratios. The grid can also display a truncated view of the data and expand to show all elements with optional expanded content.

## Preview

<table class="tg"><thead>
  <tr>
    <td class="tg-0lax"><img src="https://github.com/ElyesDer/VGrid/blob/main/Preview/Basic.png" width="100"/></td>
    <td class="tg-0lax"><img src="https://github.com/ElyesDer/VGrid/blob/main/Preview/Expandable.png" width="100"/></td>
  </tr></thead>
</table>

## Features

- **Customizable Layout**: Define the size ratios for each cell in the grid using a matrix (`GridConfiguration`).
- **Flexible Content**: Display data in the grid by passing a closure that defines how each data element should be displayed.
- **Expandable View**: Control whether the grid shows all data or truncates it to a specified limit. Provide custom content to toggle the expanded view.
- **Adjustable Spacing**: Customize horizontal (`hSpacing`) and vertical (`vSpacing`) spacing between grid cells.
- **Efficient Data Management**: Truncate the displayed data to improve performance when displaying large collections.

## Example Usage

Here's a quick example demonstrating how to use the `VGrid` component with a collection of custom data:

### Data Model

```swift
struct MyData: Identifiable, Hashable {
    let id: UUID = UUID()
    let name: String
}
```

### Sample Data

```swift
let data = [
    [MyData(name: "A"), MyData(name: "B"), MyData(name: "C")],
    [MyData(name: "D"), MyData(name: "E"), MyData(name: "F")],
    [MyData(name: "G"), MyData(name: "H"), MyData(name: "I")]
]
```

### Grid Configuration

```swift
let configuration: VGrid<MyData, Text, Empty>.GridConfiguration = [
    [.fixed(ratio: 0.333), .fixed(ratio: 0.333), .fixed(ratio: 0.333)],
    [.fixed(ratio: 0.4), .fixed(ratio: 0.4), .fixed(ratio: 0.2)],
    [.fixed(ratio: 1)]
]
```

### Grid View Implementation

```swift
var body: some View {
    VGrid(data, configuration: configuration) { data in
        Text(data.name)
    }
}
```

### Example Breakdown

- `data`: A 2D array of `MyData` objects to display in the grid.
- `configuration`: Defines how each row of the grid is laid out by specifying the size ratio for each cell in the row.
- `content`: The closure that defines how to display each data element inside the grid. In this case, we are displaying each item using a `Text` view.

## Parameters

- `data`: A collection of data elements that the grid will display.
- `configuration`: A matrix of size ratios for the grid cells. Each inner array represents a row, and each value in the row defines the width ratio for that cell.
- `vSpacing`: Vertical spacing between rows in the grid.
- `hSpacing`: Horizontal spacing between cells in the grid. If not provided, the grid uses the spacing defined in the row configuration.
- `truncateAt`: The maximum number of elements to show when `isExpanded` is `false`. If `nil`, all elements will be displayed.
- `isExpanded`: A binding to control whether the grid displays all the data or truncates it to a limited number of elements.
- `expandedContent`: Optional closure that provides custom content displayed below the grid when the grid is in its expanded state.
- `content`: A closure that generates a view for each data element in the grid.

## How It Works

1. **Grid Layout**: The grid uses a `GridConfiguration` matrix to define how each row and column should be sized. You can use `.fixed(ratio:)` to set the width of each column as a proportion of the total row width.
  
2. **Data Handling**: The `data` parameter holds the collection to be displayed. Each row in the `data` array corresponds to a row in the grid, and each element corresponds to a grid cell.

3. **Expandable Behavior**: The `isExpanded` binding controls whether all data is shown or a subset of it. When set to `true`, all elements in the collection are displayed. If `false`, the number of visible elements is limited by the `truncateAt` parameter.

4. **Custom Spacing**: You can configure the spacing between rows and columns by adjusting the `vSpacing` and `hSpacing` parameters, offering full control over the layout.

## Expandable Content Example

If you'd like to add a button that toggles between showing the full grid or a truncated version, you can use the `expandedContent` parameter:

```swift
@State private var isExpanded = false

var body: some View {
    VGrid(data, configuration: configuration, truncateAt: 6, isExpanded: $isExpanded) { data in
        Text(data.name)
    } expandedContent: {
        Button(isExpanded ? "Show Less" : "Show More") {
            isExpanded.toggle()
        }
    }
}
```

In this example, when the grid is collapsed, only the first 6 elements are displayed. The "Show More" button toggles the `isExpanded` state, revealing or hiding additional data.

## Installation

This is a SwiftUI-based library, so simply include the `VGrid` component file in your SwiftUI project. Then, you can directly use it in your SwiftUI views.

## Conclusion

The `VGrid` SwiftUI component offers a flexible and customizable way to display data in a grid layout. It supports truncating content for performance, and the grid can easily be expanded to show all data. With its layout customization features, it's perfect for building dynamic, responsive UIs in SwiftUI.
