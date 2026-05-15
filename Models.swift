import Foundation

// MARK: - Models

struct RenovationProject: Identifiable, Codable {
    var id = UUID()
    var name: String
    var room: RoomType
    var qualityLevel: QualityLevel
    var tasks: [RenovationTask]
    var photos: [ProjectPhoto]
    var createdAt: Date = Date()
}

struct RenovationTask: Identifiable, Codable {
    var id = UUID()
    var name: String
    var isCompleted: Bool = false
}

struct ProjectPhoto: Identifiable, Codable {
    var id = UUID()
    var imageData: Data
    var label: PhotoLabel
    var dateAdded: Date = Date()

    enum PhotoLabel: String, Codable, CaseIterable {
        case before = "Before"
        case after = "After"
    }
}

enum RoomType: String, Codable, CaseIterable, Identifiable {
    case kitchen = "Kitchen"
    case bathroom = "Bathroom"
    case livingRoom = "Living Room"
    case bedroom = "Bedroom"
    case basement = "Basement"
    case exterior = "Exterior"
    case other = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .kitchen: return "fork.knife"
        case .bathroom: return "shower"
        case .livingRoom: return "sofa"
        case .bedroom: return "bed.double"
        case .basement: return "square.3.layers.3d.down.right"
        case .exterior: return "house"
        case .other: return "wrench.and.screwdriver"
        }
    }

    var defaultTasks: [String] {
        switch self {
        case .kitchen:
            return ["Demo old cabinets", "Install new cabinets", "Countertop installation",
                    "Appliance hookup", "Tile backsplash", "Plumbing updates",
                    "Electrical updates", "Painting"]
        case .bathroom:
            return ["Demo old fixtures", "Install new vanity", "Tile floor & walls",
                    "Install shower/tub", "Plumbing rough-in", "Electrical & lighting",
                    "Ventilation fan", "Painting"]
        case .livingRoom:
            return ["Flooring replacement", "Paint walls & ceiling", "Crown molding",
                    "Built-in shelving", "Fireplace update", "Lighting fixtures", "Window treatments"]
        case .bedroom:
            return ["Flooring", "Paint", "Closet organizer", "Lighting", "Window treatments", "Trim & molding"]
        case .basement:
            return ["Waterproofing", "Framing", "Insulation", "Drywall",
                    "Flooring", "Electrical", "HVAC extension", "Egress window"]
        case .exterior:
            return ["Siding replacement", "Roof repair", "Deck/patio", "Landscaping",
                    "Driveway", "Gutters", "Windows & doors", "Painting"]
        case .other:
            return ["Flooring", "Painting", "Trim work", "Lighting", "Other work"]
        }
    }

    var costRange: (low: Double, high: Double) {
        switch self {
        case .kitchen: return (15000, 50000)
        case .bathroom: return (6000, 25000)
        case .livingRoom: return (3000, 18000)
        case .bedroom: return (2000, 12000)
        case .basement: return (10000, 40000)
        case .exterior: return (5000, 30000)
        case .other: return (1000, 20000)
        }
    }
}

enum QualityLevel: String, Codable, CaseIterable, Identifiable {
    case budget = "Budget"
    case standard = "Standard"
    case premium = "Premium"

    var id: String { rawValue }

    var multiplier: Double {
        switch self {
        case .budget: return 0.7
        case .standard: return 1.0
        case .premium: return 1.6
        }
    }

    var icon: String {
        switch self {
        case .budget: return "🪨"
        case .standard: return "🏠"
        case .premium: return "💎"
        }
    }

    var color: String {
        switch self {
        case .budget: return "green"
        case .standard: return "yellow"
        case .premium: return "red"
        }
    }
}

// MARK: - Cost Calculator

struct CostEstimate {
    let low: Double
    let high: Double
    var average: Double { (low + high) / 2 }

    var breakdown: [(label: String, percentage: Double)] {
        [
            ("Labor", 0.40),
            ("Materials", 0.35),
            ("Fixtures & Finishes", 0.15),
            ("Permits & Misc", 0.10)
        ]
    }

    static func calculate(room: RoomType, quality: QualityLevel) -> CostEstimate {
        let range = room.costRange
        return CostEstimate(
            low: range.low * quality.multiplier,
            high: range.high * quality.multiplier
        )
    }
}

// MARK: - Formatters

extension Double {
    var asCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "$0"
    }
}
