import Combine
import SwiftUI

@MainActor
final class PetNudgeViewModel: ObservableObject {

    let preferences: UserPreferences
    let scheduler: ReminderScheduler
    let animator: MenuBarAnimator

    @Published var showingAddReminder = false
    @Published var currentTab: PopoverTab = .reminders

    enum PopoverTab {
        case reminders
        case settings
    }

    init(preferences: UserPreferences, scheduler: ReminderScheduler, animator: MenuBarAnimator) {
        self.preferences = preferences
        self.scheduler = scheduler
        self.animator = animator
    }

    func addReminder(_ reminder: Reminder) {
        preferences.reminders.append(reminder)
    }

    func deleteReminder(at offsets: IndexSet) {
        preferences.reminders.remove(atOffsets: offsets)
    }

    func toggleReminder(id: UUID) {
        if let idx = preferences.reminders.firstIndex(where: { $0.id == id }) {
            preferences.reminders[idx].isEnabled.toggle()
        }
    }

    func snoozeReminder(id: UUID, minutes: Int = 10) {
        scheduler.snoozeReminder(id: id, minutes: minutes)
    }

    func updateCharacter(_ character: PetCharacter) {
        preferences.selectedCharacter = character
        animator.updateBaseIcon(character)
    }
}
