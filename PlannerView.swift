import SwiftUI

struct PlannerView: View {
    @Environment(ProjectStore.self) var store

    var body: some View {
        @Bindable var store = store
        NavigationStack {
            Group {
                if let project = store.currentProject {
                    ScrollView {
                        VStack(spacing: 24) {
                            ProgressCard(progress: store.progress,
                                         completed: project.tasks.filter { $0.isCompleted }.count,
                                         total: project.tasks.count)

                            VStack(alignment: .leading, spacing: 8) {
                                SectionHeader(title: "Project Name")
                                TextField("Project name", text: Binding(
                                    get: { project.name },
                                    set: { store.updateName($0) }
                                ))
                                .textFieldStyle(.roundedBorder)
                            }
                            .padding(.horizontal)

                            VStack(alignment: .leading, spacing: 12) {
                                SectionHeader(title: "Room Type")
                                    .padding(.horizontal)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(RoomType.allCases) { room in
                                            RoomChip(room: room, isSelected: project.room == room) {
                                                store.updateRoom(room)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                SectionHeader(title: "Task Checklist")
                                    .padding(.horizontal)
                                VStack(spacing: 8) {
                                    ForEach(project.tasks) { task in
                                        TaskRow(task: task) { store.toggleTask(task) }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                } else {
                    ContentUnavailableView("No Project", systemImage: "folder.badge.plus",
                                          description: Text("Go to Projects tab to create one"))
                }
            }
            .navigationTitle(store.currentProject?.name ?? "RenovateIQ")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ProgressCard: View {
    let progress: Double
    let completed: Int
    let total: Int

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Project Progress")
                    .font(.subheadline).foregroundColor(.secondary)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.subheadline).fontWeight(.semibold).foregroundColor(.orange)
            }
            ProgressView(value: progress).tint(.orange).scaleEffect(x: 1, y: 2, anchor: .center)
            HStack {
                Text("\(completed) of \(total) tasks completed")
                    .font(.caption).foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

struct RoomChip: View {
    let room: RoomType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: room.icon).font(.caption)
                Text(room.rawValue).font(.subheadline).fontWeight(.medium)
            }
            .padding(.horizontal, 14).padding(.vertical, 8)
            .background(isSelected ? Color.orange.opacity(0.15) : Color(.secondarySystemBackground))
            .foregroundColor(isSelected ? .orange : .secondary)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(isSelected ? Color.orange : Color.clear, lineWidth: 1.5))
        }
    }
}

struct TaskRow: View {
    let task: RenovationTask
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(task.isCompleted ? Color.orange : Color.secondary.opacity(0.4), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    if task.isCompleted {
                        RoundedRectangle(cornerRadius: 6).fill(Color.orange).frame(width: 24, height: 24)
                        Image(systemName: "checkmark").font(.caption.bold()).foregroundColor(.white)
                    }
                }
                Text(task.name).font(.body)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                    .strikethrough(task.isCompleted)
                Spacer()
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
            .background(task.isCompleted ? Color.orange.opacity(0.05) : Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .animation(.easeInOut(duration: 0.2), value: task.isCompleted)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PlannerView().environment(ProjectStore())
}
