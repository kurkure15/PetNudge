import Foundation

enum ReminderCategory: String, Codable, CaseIterable, Identifiable {
    case hydration
    case breakTime
    case stretch
    case medication
    case custom

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .hydration:  return "Drink Water"
        case .breakTime:  return "Take a Break"
        case .stretch:    return "Stretch"
        case .medication: return "Medication"
        case .custom:     return "Custom"
        }
    }

    var emoji: String {
        switch self {
        case .hydration:  return "💧"
        case .breakTime:  return "☕️"
        case .stretch:    return "🧘"
        case .medication: return "💊"
        case .custom:     return "📝"
        }
    }

    var defaultIntervalMinutes: Int {
        switch self {
        case .hydration:  return 30
        case .breakTime:  return 60
        case .stretch:    return 45
        case .medication: return 480
        case .custom:     return 60
        }
    }
}
