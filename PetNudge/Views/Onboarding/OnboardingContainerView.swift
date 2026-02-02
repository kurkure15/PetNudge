import SwiftUI

struct OnboardingContainerView: View {
    @EnvironmentObject var preferences: UserPreferences
    let onComplete: () -> Void

    @State private var currentStep = 0

    var body: some View {
        VStack(spacing: 0) {
            // Progress dots (only shown on step 2 — steps 0 and 1 are full-bleed)
            if currentStep == 2 {
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { step in
                        Capsule()
                            .fill(step <= currentStep ? Color.accentColor : Color.gray.opacity(0.3))
                            .frame(height: 4)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)
            }

            // Step content
            if currentStep == 0 {
                CharacterSelectionView(
                    selectedCharacter: $preferences.selectedCharacter,
                    onComplete: { withAnimation { currentStep = 1 } }
                )
            } else if currentStep == 1 {
                FirstReminderView(
                    character: preferences.selectedCharacter,
                    onReminderCreated: { reminder in
                        preferences.reminders.append(reminder)
                        withAnimation { currentStep = 2 }
                    },
                    onBack: { withAnimation { currentStep = 0 } }
                )
            } else {
                ReminderSetupView(
                    reminders: $preferences.reminders,
                    onComplete: onComplete
                )
            }
        }
        .frame(width: 1200, height: 640)
    }
}
