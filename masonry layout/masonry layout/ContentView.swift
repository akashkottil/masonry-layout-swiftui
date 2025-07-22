import SwiftUI
struct HomeView: View {
    @State private var numberOfColumns = 2

    let images: [MasonryImage] = [
        .init(imageName: "https://picsum.photos/id/10/300/300", height: 200),
        .init(imageName: "https://picsum.photos/id/20/300/200", height: 150),
        .init(imageName: "https://picsum.photos/id/30/300/250", height: 300),
        .init(imageName: "https://picsum.photos/id/40/300/150", height: 180),
        .init(imageName: "https://picsum.photos/id/50/300/350", height: 220),
        .init(imageName: "https://picsum.photos/id/60/300/300", height: 260),
    ]

    var body: some View {
        VStack {
            Picker("Columns", selection: $numberOfColumns) {
                ForEach(1...4, id: \.self) { count in
                    Text("\(count)").tag(count)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            MasonryGrid(data: images, columns: numberOfColumns, spacing: 12) { item in
                AsyncImage(url: URL(string: item.imageName)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: item.height)
                            .background(Color.gray.opacity(0.2))

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: item.height)
                            .clipped()
                            .cornerRadius(10)

                    case .failure:
                        Color.red
                            .frame(height: item.height)
                            .overlay(Image(systemName: "xmark.octagon"))

                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
    }
}
