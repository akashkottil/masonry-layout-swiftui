import SwiftUI

struct MasonryGrid<T: Identifiable, Content: View>: View {
    let data: [T]
    let columns: Int
    let spacing: CGFloat
    let content: (T) -> Content

    private func distributeItems() -> [[T]] {
        var grid = Array(repeating: [T](), count: columns)
        var columnHeights = Array(repeating: CGFloat.zero, count: columns)

        for item in data {
            let shortestIndex = columnHeights.firstIndex(of: columnHeights.min() ?? 0) ?? 0
            grid[shortestIndex].append(item)
            columnHeights[shortestIndex] += 1 // you can improve this with actual height if known
        }

        return grid
    }

    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                let totalSpacing = spacing * CGFloat(columns - 1)
                let itemWidth = (geometry.size.width - totalSpacing) / CGFloat(columns)

                let columnData = distributeItems()

                HStack(alignment: .top, spacing: spacing) {
                    ForEach(0..<columns, id: \.self) { columnIndex in
                        VStack(spacing: spacing) {
                            ForEach(columnData[columnIndex]) { item in
                                content(item)
                                    .frame(width: itemWidth)
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width, alignment: .top)
            }
            .padding(.horizontal)
        }
    }
}
