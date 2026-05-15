import Foundation
import SwiftUI
import Observation

@Observable
class ProjectStore {
    var projects: [RenovationProject] = []
    var selectedProjectIndex: Int = 0

    var currentProject: RenovationProject? {
        projects.isEmpty ? nil : projects[selectedProjectIndex]
    }

    init() {
        load()
        if projects.isEmpty {
            let defaultProject = RenovationProject(
                name: "My Kitchen Remodel",
                room: .kitchen,
                qualityLevel: .standard,
                tasks: RoomType.kitchen.defaultTasks.map { RenovationTask(name: $0) },
                photos: []
            )
            projects.append(defaultProject)
            save()
        }
    }

    // MARK: - Project Management

    func addProject(name: String, room: RoomType) {
        let project = RenovationProject(
            name: name,
            room: room,
            qualityLevel: .standard,
            tasks: room.defaultTasks.map { RenovationTask(name: $0) },
            photos: []
        )
        projects.append(project)
        selectedProjectIndex = projects.count - 1
        save()
    }

    func deleteProject(at offsets: IndexSet) {
        projects.remove(atOffsets: offsets)
        if selectedProjectIndex >= projects.count {
            selectedProjectIndex = max(0, projects.count - 1)
        }
        save()
    }

    func selectProject(at index: Int) {
        selectedProjectIndex = index
    }

    // MARK: - Current Project Computed Props

    var estimate: CostEstimate {
        guard let p = currentProject else { return CostEstimate(low: 0, high: 0) }
        return CostEstimate.calculate(room: p.room, quality: p.qualityLevel)
    }

    var progress: Double {
        guard let p = currentProject, !p.tasks.isEmpty else { return 0 }
        let completed = p.tasks.filter { $0.isCompleted }.count
        return Double(completed) / Double(p.tasks.count)
    }

    // MARK: - Mutations

    func updateRoom(_ room: RoomType) {
        guard !projects.isEmpty else { return }
        projects[selectedProjectIndex].room = room
        projects[selectedProjectIndex].tasks = room.defaultTasks.map { RenovationTask(name: $0) }
        save()
    }

    func updateName(_ name: String) {
        guard !projects.isEmpty else { return }
        projects[selectedProjectIndex].name = name
        save()
    }

    func updateQuality(_ quality: QualityLevel) {
        guard !projects.isEmpty else { return }
        projects[selectedProjectIndex].qualityLevel = quality
        save()
    }

    func toggleTask(_ task: RenovationTask) {
        guard !projects.isEmpty else { return }
        if let i = projects[selectedProjectIndex].tasks.firstIndex(where: { $0.id == task.id }) {
            projects[selectedProjectIndex].tasks[i].isCompleted.toggle()
            save()
        }
    }

    func addPhoto(_ data: Data, label: ProjectPhoto.PhotoLabel) {
        guard !projects.isEmpty else { return }
        projects[selectedProjectIndex].photos.append(ProjectPhoto(imageData: data, label: label))
        save()
    }

    func togglePhotoLabel(_ photo: ProjectPhoto) {
        guard !projects.isEmpty else { return }
        if let i = projects[selectedProjectIndex].photos.firstIndex(where: { $0.id == photo.id }) {
            projects[selectedProjectIndex].photos[i].label =
                projects[selectedProjectIndex].photos[i].label == .before ? .after : .before
            save()
        }
    }

    func removePhoto(_ photo: ProjectPhoto) {
        guard !projects.isEmpty else { return }
        projects[selectedProjectIndex].photos.removeAll { $0.id == photo.id }
        save()
    }

    // MARK: - Persistence

    private let saveKey = "renovateiq_projects"

    func save() {
        if let encoded = try? JSONEncoder().encode(projects) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([RenovationProject].self, from: data) {
            projects = decoded
        }
    }
}
