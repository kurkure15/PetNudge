import Foundation

struct Reminder: Codable, Identifiable, Equatable {
    let id: UUID
    var category: ReminderCategory
    var customTitle: String?
    var intervalMinutes: Int
    var isEnabled: Bool
    var lastTriggeredDate: Date?
    var snoozedUntil: Date?

    var displayTitle: String {
        if let custom = customTitle, category == .custom {
            return custom
        }
        return category.displayName
    }

    var nextFireDate: Date? {
        guard isEnabled else { return nil }
        if let snoozed = snoozedUntil, snoozed > Date() {
            return snoozed
        }
        let base = lastTriggeredDate ?? Date()
        return base.addingTimeInterval(TimeInterval(intervalMinutes * 60))
    }

    init(
        id: UUID = UUID(),
        category: ReminderCategory,
        customTitle: String? = nil,
        intervalMinutes: Int? = nil,
        isEnabled: Bool = true
    ) {
        self.id = id
        self.category = category
        self.customTitle = customTitle
        self.intervalMinutes = intervalMinutes ?? category.defaultIntervalMinutes
        self.isEnabled = isEnabled
        self.lastTriggeredDate = nil
        self.snoozedUntil = nil
    }
}
