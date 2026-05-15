import SwiftUI
import PhotosUI

struct PhotosView: View {
    @Environment(ProjectStore.self) var store
    @State private var selectedItems: [PhotosPickerItem] = []

    var project: RenovationProject? { store.currentProject }
    var beforePhotos: [ProjectPhoto] { project?.photos.filter { $0.label == .before } ?? [] }
    var afterPhotos: [ProjectPhoto] { project?.photos.filter { $0.label == .after } ?? [] }

    var body: some View {
        NavigationStack {
            Group {
                if project != nil {
                    ScrollView {
                        VStack(spacing: 24) {
                            PhotosPicker(selection: $selectedItems, maxSelectionCount: 10, matching: .images) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Photos").fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity).padding()
                                .background(Color.orange.opacity(0.12))
                                .foregroundColor(.orange)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.orange.opacity(0.3), lineWidth: 1.5))
                            }
                            .padding(.horizontal)
                            .onChange(of: selectedItems) { _, newItems in
                                Task {
                                    for item in newItems {
                                        if let data = try? await item.loadTransferable(type: Data.self) {
                                            store.addPhoto(data, label: .before)
                                        }
                                    }
                                    selectedItems = []
                                }
                            }

                            if (project?.photos ?? []).isEmpty {
                                EmptyPhotosView()
                            } else {
                                if !beforePhotos.isEmpty { PhotoSection(title: "Before", photos: beforePhotos) }
                                if !afterPhotos.isEmpty { PhotoSection(title: "After", photos: afterPhotos) }
                                Text("Tap a photo label to toggle Before / After")
                                    .font(.caption).foregroundColor(.secondary).padding(.bottom)
                            }
                        }
                        .padding(.vertical)
                    }
                } else {
                    ContentUnavailableView("No Project", systemImage: "folder.badge.plus",
                                          description: Text("Go to Projects tab to create one"))
                }
            }
            .navigationTitle("Photos")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct PhotoSection: View {
    @Environment(ProjectStore.self) var store
    let title: String
    let photos: [ProjectPhoto]
    var labelColor: Color { title == "Before" ? .blue : .green }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title).font(.headline)
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(labelColor.opacity(0.15)).foregroundColor(labelColor).clipShape(Capsule())
                Spacer()
                Text("\(photos.count) photo\(photos.count == 1 ? "" : "s")").font(.caption).foregroundColor(.secondary)
            }
            .padding(.horizontal)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(photos) { photo in PhotoThumbnail(photo: photo) }
            }
            .padding(.horizontal)
        }
    }
}

struct PhotoThumbnail: View {
    @Environment(ProjectStore.self) var store
    let photo: ProjectPhoto
    var labelColor: Color { photo.label == .before ? Color.blue : Color.green }

    var body: some View {
        ZStack(alignment: .topLeading) {
            if let uiImage = UIImage(data: photo.imageData) {
                Image(uiImage: uiImage)
                    .resizable().aspectRatio(4/3, contentMode: .fill)
                    .clipped().clipShape(RoundedRectangle(cornerRadius: 12))
            }
            Button { store.togglePhotoLabel(photo) } label: {
                Text(photo.label.rawValue).font(.caption.bold()).foregroundColor(.white)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(labelColor).clipShape(Capsule()).padding(8)
            }
        }
        .contextMenu {
            Button(role: .destructive) { store.removePhoto(photo) } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct EmptyPhotosView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "photo.on.rectangle.angled").font(.system(size: 48)).foregroundColor(.secondary.opacity(0.4))
            Text("No photos yet").font(.headline).foregroundColor(.secondary)
            Text("Add before & after photos to track your renovation progress")
                .font(.subheadline).foregroundColor(.secondary.opacity(0.7)).multilineTextAlignment(.center)
        }
        .padding(40)
    }
}

#Preview {
    PhotosView().environment(ProjectStore())
}
