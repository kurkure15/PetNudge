import SwiftUI

struct OnboardingContainerView: View {
    @EnvironmentObject var preferences: UserPreferences
    let onComplete: () -> Void

    @State private var currentStep = 0

    var body: some View {
        VStack(spacing: 0) {
            // Progress dots
            HStack(spacing: 8) {
                ForEach(0..<2, id: \.self) { step in
                    Capsule()
                        .fill(step <= currentStep ? Color.accentColor : Color.gray.opacity(0.3))
                        .frame(height: 4)
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 24)

            // Step content
            if currentStep == 0 {
                CharacterPickerView(
                    selectedCharacter: $preferences.selectedCharacter,
                    onNext: { withAnimation { currentStep = 1 } }
                )
            } else {
                ReminderSetupView(
                    reminders: $preferences.reminders,
                    onComplete: onComplete
                )
            }
        }
        .frame(width: 480, height: 520)
    }
}
