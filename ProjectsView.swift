import SwiftUI

struct ProjectsView: View {
    @Environment(ProjectStore.self) var store
    @State private var showingAdd = false
    @State private var newName = ""
    @State private var newRoom = RoomType.kitchen

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(store.projects.enumerated()), id: \.element.id) { index, project in
                    Button {
                        store.selectProject(at: index)
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: project.room.icon)
                                .font(.title3)
                                .foregroundColor(.orange)
                                .frame(width: 36, height: 36)
                                .background(Color.orange.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                            VStack(alignment: .leading, spacing: 3) {
                                Text(project.name)
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                Text(project.room.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                ProgressView(value: progressFor(project))
                                    .tint(.orange)
                                    .frame(width: 120)
                            }
                            Spacer()
                            if index == store.selectedProjectIndex {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete { store.deleteProject(at: $0) }
            }
            .navigationTitle("My Projects")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddProjectSheet(isPresented: $showingAdd)
            }
        }
    }

    func progressFor(_ project: RenovationProject) -> Double {
        guard !project.tasks.isEmpty else { return 0 }
        return Double(project.tasks.filter { $0.isCompleted }.count) / Double(project.tasks.count)
    }
}

struct AddProjectSheet: View {
    @Environment(ProjectStore.self) var store
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var room = RoomType.kitchen

    var body: some View {
        NavigationStack {
            Form {
                Section("Project Details") {
                    TextField("Project name e.g. Bathroom Refresh", text: $name)
                    Picker("Room", selection: $room) {
                        ForEach(RoomType.allCases) { r in
                            Label(r.rawValue, systemImage: r.icon).tag(r)
                        }
                    }
                }
            }
            .navigationTitle("New Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        let n = name.trimmingCharacters(in: .whitespaces)
                        store.addProject(name: n.isEmpty ? "\(room.rawValue) Renovation" : n, room: room)
                        isPresented = false
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    ProjectsView()
        .environment(ProjectStore())
}
