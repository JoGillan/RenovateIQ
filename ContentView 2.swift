import SwiftUI

struct ContentView: View {
    @State private var store = ProjectStore()
    @State private var showingAddProject = false
    @State private var newProjectName = ""
    @State private var newProjectRoom = RoomType.kitchen

    var body: some View {
        TabView {
            PlannerView()
                .tabItem { Label("Plan", systemImage: "checklist") }

            BudgetView()
                .tabItem { Label("Budget", systemImage: "dollarsign.circle") }

            PhotosView()
                .tabItem { Label("Photos", systemImage: "photo.on.rectangle") }

            ProjectsView()
                .tabItem { Label("Projects", systemImage: "folder") }
        }
        .environment(store)
        .tint(Color.orange)
    }
}

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title.uppercased())
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            .tracking(1.2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ContentView()
}
