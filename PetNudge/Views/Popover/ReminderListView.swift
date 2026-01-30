import SwiftUI

struct ReminderListView: View {
    @EnvironmentObject var viewModel: PetNudgeViewModel
    @EnvironmentObject var preferences: UserPreferences

    var body: some View {
        VStack(spacing: 0) {
            if preferences.reminders.isEmpty {
                Spacer()
                Text("No reminders yet")
                    .foregroundStyle(.secondary)
                Text("Tap + to add your first nudge")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                Spacer()
            } else {
                List {
                    ForEach(preferences.reminders) { reminder in
                        ReminderRowView(reminder: reminder)
                            .environmentObject(viewModel)
                    }
                    .onDelete(perform: viewModel.deleteReminder)
                }
                .listStyle(.plain)
            }

            Divider()

            Button(action: { viewModel.showingAddReminder = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Reminder")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }
            .buttonStyle(.plain)
            .foregroundStyle(Color.accentColor)
        }
        .sheet(isPresented: $viewModel.showingAddReminder) {
            AddReminderView()
                .environmentObject(viewModel)
        }
    }
}
