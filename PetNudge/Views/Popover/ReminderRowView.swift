import SwiftUI

struct ReminderRowView: View {
    let reminder: Reminder
    @EnvironmentObject var viewModel: PetNudgeViewModel

    var body: some View {
        HStack(spacing: 12) {
            Text(reminder.category.emoji)
                .font(.title2)

            VStack(alignment: .leading, spacing: 2) {
                Text(reminder.displayTitle)
                    .font(.body)
                    .foregroundStyle(reminder.isEnabled ? .primary : .secondary)

                if let next = reminder.nextFireDate {
                    Text(relativeTimeString(from: next))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Paused")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer()

            if reminder.isEnabled {
                Button(action: { viewModel.snoozeReminder(id: reminder.id) }) {
                    Image(systemName: "moon.zzz")
                        .font(.caption)
                }
                .buttonStyle(.plain)
                .help("Snooze 10 minutes")
            }

            Toggle("", isOn: Binding(
                get: { reminder.isEnabled },
                set: { _ in viewModel.toggleReminder(id: reminder.id) }
            ))
            .toggleStyle(.switch)
            .controlSize(.small)
            .labelsHidden()
        }
        .padding(.vertical, 4)
    }

    private func relativeTimeString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return "Next " + formatter.localizedString(for: date, relativeTo: Date())
    }
}
