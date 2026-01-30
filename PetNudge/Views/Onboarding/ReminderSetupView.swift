import SwiftUI

struct ReminderSetupView: View {
    @Binding var reminders: [Reminder]
    let onComplete: () -> Void

    @State private var selectedCategories: Set<ReminderCategory> = [.hydration, .breakTime]

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("What should I remind you?")
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text("Pick the nudges you want. You can always\nadd more later from the menu bar.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                ForEach(ReminderCategory.allCases.filter { $0 != .custom }) { category in
                    Button(action: { toggleCategory(category) }) {
                        HStack {
                            Text(category.emoji)
                                .font(.title2)
                            Text(category.displayName)
                                .font(.body)
                            Spacer()
                            Text("Every \(category.defaultIntervalMinutes) min")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Image(systemName: selectedCategories.contains(category)
                                ? "checkmark.circle.fill"
                                : "circle")
                                .foregroundStyle(selectedCategories.contains(category)
                                    ? Color.accentColor
                                    : Color.gray.opacity(0.4))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(selectedCategories.contains(category)
                                    ? Color.accentColor.opacity(0.08)
                                    : Color.gray.opacity(0.06))
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 32)

            Spacer()

            Button(action: {
                reminders = selectedCategories.map { category in
                    Reminder(category: category)
                }
                onComplete()
            }) {
                Text("Let's Go!")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(selectedCategories.isEmpty)
            .padding(.horizontal, 32)
            .padding(.bottom, 24)
        }
    }

    private func toggleCategory(_ category: ReminderCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
}
