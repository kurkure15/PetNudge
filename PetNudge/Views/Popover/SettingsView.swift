import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: PetNudgeViewModel
    @EnvironmentObject var preferences: UserPreferences

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Character selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Companion")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                        ForEach(PetCharacter.allCases) { character in
                            Button(action: { viewModel.updateCharacter(character) }) {
                                VStack(spacing: 4) {
                                    Image(nsImage: character.idleIcon)
                                        .resizable()
                                        .interpolation(.high)
                                        .frame(width: 28, height: 28)
                                    Text(character.displayName)
                                        .font(.caption2)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(preferences.selectedCharacter == character
                                            ? Color.accentColor.opacity(0.15)
                                            : Color.clear)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Divider()

                // Notification preferences
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notifications")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Toggle("System Notifications", isOn: $preferences.notificationsEnabled)
                    Toggle("Menu Bar Animation", isOn: $preferences.menuBarAnimationEnabled)
                }

                Divider()

                // Quit button
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    HStack {
                        Image(systemName: "power")
                        Text("Quit PetNudge")
                    }
                    .foregroundStyle(.red)
                }
                .buttonStyle(.plain)
            }
            .padding(16)
        }
    }
}
