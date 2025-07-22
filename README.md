# 🧱 SwiftUI Masonry Layout (Pinterest-style Grid)

A reusable, responsive Masonry layout (like Pinterest) built using SwiftUI — perfect for showcasing image galleries with variable heights.

[Watch Demo Video](./demo.mp4)

## 🚀 Features

- ✅ Fully responsive column-based layout
- ✅ Customizable number of columns (1 to N)
- ✅ Clean and reusable component
- ✅ Lightweight with native SwiftUI
- ✅ Handles remote image loading with fallback
- ✅ Dynamically adapts image height while preserving aspect ratio

---

## 📦 Installation

Just copy the following files into your SwiftUI project:

📁 MasonryGrid/
├── MasonryGrid.swift
├── MasonryImage.swift
├── HomeView.swift


## 🛠️ Usage

### Step 1: Define your data model

```swift
struct MasonryImage: Identifiable {
    let id = UUID()
    let imageName: String
    let height: CGFloat
}
```
Step 2: Use the MasonryGrid in your view

```swift

struct HomeView: View {
    @State private var numberOfColumns: Int = 2

    let images: [MasonryImage] = [
        .init(imageName: "https://picsum.photos/200/300", height: 200),
        .init(imageName: "https://picsum.photos/200", height: 150),
        .init(imageName: "https://picsum.photos/id/237/200/300", height: 300),
        .init(imageName: "https://picsum.photos/200/300/?blur", height: 180),
        .init(imageName: "https://picsum.photos/200/600/?blur", height: 220),
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                Picker("Columns", selection: $numberOfColumns) {
                    ForEach(1...4, id: \.self) { count in
                        Text("\(count)").tag(count)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                MasonryGrid(data: images, columns: numberOfColumns) { item in
                    GeometryReader { geo in
                        let width = geo.size.width
                        let aspectRatio = 3 / 2.0
                        let adjustedHeight = item.height * (width / 200)

                        AsyncImage(url: URL(string: item.imageName)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: width, height: adjustedHeight)
                        .clipped()
                        .cornerRadius(10)
                    }
                    .frame(height: item.height)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Masonry Layout")
        }
    }
}
```
🧱 MasonryGrid.swift
```swift

struct MasonryGrid<T: Identifiable, Content: View>: View {
    let data: [T]
    let columns: Int
    let content: (T) -> Content

    init(data: [T], columns: Int, @ViewBuilder content: @escaping (T) -> Content) {
        self.data = data
        self.columns = columns
        self.content = content
    }

    private func splitDataIntoColumns() -> [[T]] {
        var columnsArray = Array(repeating: [T](), count: columns)
        for (index, item) in data.enumerated() {
            columnsArray[index % columns].append(item)
        }
        return columnsArray
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            ForEach(splitDataIntoColumns(), id: \.self) { column in
                VStack(spacing: 8) {
                    ForEach(column) { item in
                        content(item)
                    }
                }
            }
        }
    }
}
```

📸 Preview

```swift

#Preview {
    HomeView()
}
```

💡 Tips
You can integrate image caching using libraries like NukeUI, SDWebImageSwiftUI, or Kingfisher for better performance.

Easily adapt this layout for other variable-height content like cards, posts, or videos.

🧑‍💻 Author
Akash Kottil
Product Engineer · Indie Maker · Founder of Zelexto

📃 License
MIT License – free to use, share, and modify!

🤝 Contributing
Found a bug or want to suggest a feature? PRs are welcome!
