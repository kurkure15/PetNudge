import Foundation
import Combine

@MainActor
final class UserPreferences: ObservableObject {

    static let shared = UserPreferences()

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let selectedCharacter = "selectedCharacter"
        static let reminders = "reminders"
        static let notificationsEnabled = "notificationsEnabled"
        static let menuBarAnimationEnabled = "menuBarAnimationEnabled"
    }

    @Published var hasCompletedOnboarding: Bool {
        didSet { defaults.set(hasCompletedOnboarding, forKey: Keys.hasCompletedOnboarding) }
    }

    @Published var selectedCharacter: PetCharacter {
        didSet { defaults.set(selectedCharacter.rawValue, forKey: Keys.selectedCharacter) }
    }

    @Published var reminders: [Reminder] {
        didSet { saveReminders() }
    }

    @Published var notificationsEnabled: Bool {
        didSet { defaults.set(notificationsEnabled, forKey: Keys.notificationsEnabled) }
    }

    @Published var menuBarAnimationEnabled: Bool {
        didSet { defaults.set(menuBarAnimationEnabled, forKey: Keys.menuBarAnimationEnabled) }
    }

    private init() {
        self.hasCompletedOnboarding = defaults.bool(forKey: Keys.hasCompletedOnboarding)

        let charRaw = defaults.string(forKey: Keys.selectedCharacter) ?? PetCharacter.cat.rawValue
        self.selectedCharacter = PetCharacter(rawValue: charRaw) ?? .cat

        self.notificationsEnabled = defaults.object(forKey: Keys.notificationsEnabled) as? Bool ?? true
        self.menuBarAnimationEnabled = defaults.object(forKey: Keys.menuBarAnimationEnabled) as? Bool ?? true

        if let data = defaults.data(forKey: Keys.reminders),
           let decoded = try? JSONDecoder().decode([Reminder].self, from: data) {
            self.reminders = decoded
        } else {
            self.reminders = []
        }
    }

    private func saveReminders() {
        if let data = try? JSONEncoder().encode(reminders) {
            defaults.set(data, forKey: Keys.reminders)
        }
    }
}
