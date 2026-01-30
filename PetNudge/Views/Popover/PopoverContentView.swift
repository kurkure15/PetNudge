import SwiftUI

struct PopoverContentView: View {
    @EnvironmentObject var viewModel: PetNudgeViewModel
    @EnvironmentObject var preferences: UserPreferences

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("\(preferences.selectedCharacter.emoji) PetNudge")
                    .font(.headline)
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.currentTab = viewModel.currentTab == .reminders
                            ? .settings : .reminders
                    }
                }) {
                    Image(systemName: viewModel.currentTab == .reminders
                        ? "gearshape" : "list.bullet")
                        .font(.body)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            // Content
            switch viewModel.currentTab {
            case .reminders:
                ReminderListView()
                    .environmentObject(viewModel)
                    .environmentObject(preferences)
            case .settings:
                SettingsView()
                    .environmentObject(viewModel)
                    .environmentObject(preferences)
            }
        }
        .frame(width: 320, height: 440)
    }
}
