import Combine
import Foundation
import UserNotifications

@MainActor
final class ReminderScheduler: ObservableObject {

    private var timer: Timer?
    private let preferences: UserPreferences
    private let animator: MenuBarAnimator
    private let checkInterval: TimeInterval = 15

    init(preferences: UserPreferences, animator: MenuBarAnimator) {
        self.preferences = preferences
        self.animator = animator
    }

    func start() {
        requestNotificationPermission()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: checkInterval, repeats: true) { @Sendable [weak self] _ in
            Task { @MainActor in
                self?.checkReminders()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func checkReminders() {
        let now = Date()
        var anyApproaching = false

        for i in preferences.reminders.indices {
            guard preferences.reminders[i].isEnabled else { continue }

            if let snoozed = preferences.reminders[i].snoozedUntil, snoozed > now {
                continue
            }

            let last = preferences.reminders[i].lastTriggeredDate ?? Date.distantPast
            let interval = TimeInterval(preferences.reminders[i].intervalMinutes * 60)
            let elapsed = now.timeIntervalSince(last)

            if elapsed >= interval {
                fireReminder(preferences.reminders[i])
                preferences.reminders[i].lastTriggeredDate = now
                preferences.reminders[i].snoozedUntil = nil
            } else if (interval - elapsed) <= 300 {
                // Within 5 minutes of firing — show "watching" state
                anyApproaching = true
            }
        }

        // Update menu bar icon state
        if !animator.isAnimating {
            if anyApproaching {
                animator.showWatchingState()
            } else {
                animator.showIdleState()
            }
        }
    }

    private func fireReminder(_ reminder: Reminder) {
        if preferences.notificationsEnabled {
            sendNotification(for: reminder)
        }
        if preferences.menuBarAnimationEnabled {
            animator.startAnimation(for: reminder)
        }
    }

    private func sendNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "\(preferences.selectedCharacter.emoji) PetNudge"
        content.body = "\(reminder.category.emoji) Time to \(reminder.displayTitle.lowercased())!"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: reminder.id.uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { @Sendable _, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }

    func snoozeReminder(id: UUID, minutes: Int = 10) {
        if let idx = preferences.reminders.firstIndex(where: { $0.id == id }) {
            preferences.reminders[idx].snoozedUntil = Date().addingTimeInterval(TimeInterval(minutes * 60))
        }
    }
}
