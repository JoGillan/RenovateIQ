import SwiftUI

struct BudgetView: View {
    @Environment(ProjectStore.self) var store

    var body: some View {
        NavigationStack {
            Group {
                if let project = store.currentProject {
                    ScrollView {
                        VStack(spacing: 24) {
                            EstimateCard(estimate: store.estimate, room: project.room, quality: project.qualityLevel)

                            VStack(alignment: .leading, spacing: 12) {
                                SectionHeader(title: "Quality Level").padding(.horizontal)
                                HStack(spacing: 12) {
                                    ForEach(QualityLevel.allCases) { level in
                                        QualityCard(level: level, isSelected: project.qualityLevel == level) {
                                            store.updateQuality(level)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }

                            VStack(alignment: .leading, spacing: 12) {
                                SectionHeader(title: "Cost Breakdown").padding(.horizontal)
                                VStack(spacing: 10) {
                                    ForEach(store.estimate.breakdown, id: \.label) { item in
                                        BreakdownRow(label: item.label,
                                                     amount: store.estimate.average * item.percentage,
                                                     percentage: item.percentage)
                                    }
                                }
                                .padding(.horizontal)
                            }

                            BudgetTipsCard().padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                } else {
                    ContentUnavailableView("No Project", systemImage: "folder.badge.plus",
                                          description: Text("Go to Projects tab to create one"))
                }
            }
            .navigationTitle("Budget")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct EstimateCard: View {
    let estimate: CostEstimate
    let room: RoomType
    let quality: QualityLevel

    var body: some View {
        VStack(spacing: 8) {
            Text("\(room.rawValue) · \(quality.rawValue)")
                .font(.caption).foregroundColor(.secondary).tracking(0.5)
            Text(estimate.average.asCurrency)
                .font(.system(size: 48, weight: .bold, design: .rounded)).foregroundColor(.orange)
            Text("\(estimate.low.asCurrency) – \(estimate.high.asCurrency)")
                .font(.subheadline).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28).padding(.horizontal)
        .background(LinearGradient(colors: [Color.orange.opacity(0.12), Color.orange.opacity(0.04)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.orange.opacity(0.2), lineWidth: 1))
        .padding(.horizontal)
    }
}

struct QualityCard: View {
    let level: QualityLevel
    let isSelected: Bool
    let action: () -> Void

    var accentColor: Color {
        switch level {
        case .budget: return .green
        case .standard: return .orange
        case .premium: return .red
        }
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(level.icon).font(.title2)
                Text(level.rawValue).font(.caption).fontWeight(.semibold)
                Text("\(String(format: "%.1f", level.multiplier))x").font(.caption2).foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity).padding(.vertical, 14)
            .background(isSelected ? accentColor.opacity(0.12) : Color(.secondarySystemBackground))
            .foregroundColor(isSelected ? accentColor : .secondary)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(isSelected ? accentColor : Color.clear, lineWidth: 2))
            .animation(.easeInOut(duration: 0.15), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

struct BreakdownRow: View {
    let label: String
    let amount: Double
    let percentage: Double

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(label).font(.subheadline).foregroundColor(.secondary)
                Spacer()
                Text(amount.asCurrency).font(.subheadline).fontWeight(.semibold).foregroundColor(.orange)
            }
            ProgressView(value: percentage).tint(.orange)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct BudgetTipsCard: View {
    let tips = [
        "Get 3+ contractor quotes before committing",
        "Add a 15–20% contingency buffer to your budget",
        "Permits are required for structural changes",
        "Consider phasing work to spread out costs"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Budget Tips", systemImage: "lightbulb.fill")
                .font(.subheadline).fontWeight(.semibold).foregroundColor(.orange)
            ForEach(tips, id: \.self) { tip in
                HStack(alignment: .top, spacing: 8) {
                    Text("·").foregroundColor(.orange)
                    Text(tip).font(.subheadline).foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    BudgetView().environment(ProjectStore())
}
