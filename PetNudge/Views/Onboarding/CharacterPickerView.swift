import SwiftUI

struct CharacterPickerView: View {
    @Binding var selectedCharacter: PetCharacter
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("Choose Your Companion")
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text("This little friend will live in your menu bar\nand remind you to take care of yourself.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(PetCharacter.allCases) { character in
                    Button(action: { selectedCharacter = character }) {
                        VStack(spacing: 8) {
                            Image(nsImage: character.idleIcon)
                                .resizable()
                                .interpolation(.high)
                                .frame(width: 48, height: 48)
                            Text(character.displayName)
                                .font(.caption)
                                .foregroundStyle(.primary)
                        }
                        .frame(width: 100, height: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(selectedCharacter == character
                                    ? Color.accentColor.opacity(0.15)
                                    : Color.gray.opacity(0.08))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(selectedCharacter == character
                                    ? Color.accentColor
                                    : Color.clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 32)

            Spacer()

            Button(action: onNext) {
                Text("Next")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 32)
            .padding(.bottom, 24)
        }
    }
}
