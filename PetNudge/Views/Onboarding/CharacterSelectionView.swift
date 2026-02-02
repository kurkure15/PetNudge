import SwiftUI

struct CharacterSelectionView: View {
    @Binding var selectedCharacter: PetCharacter
    let onComplete: () -> Void

    var body: some View {
        ZStack {
            // Full dark gradient background
            characterGradient
                .ignoresSafeArea()

            // Main layout — absolute positioning to match Figma
            ZStack(alignment: .topLeading) {

                // MARK: - Close button (top-left, 48x48 at 24,24)
                Button(action: {}) {
                    Image("ic_cross")
                        .resizable()
                        .interpolation(.high)
                        .frame(width: 48, height: 48)
                }
                .buttonStyle(.plain)
                .position(x: 24 + 24, y: 24 + 24)

                // MARK: - Settings button (top-right, 48x48 at 1128,24)
                Button(action: {}) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white)
                        .frame(width: 48, height: 48)
                }
                .buttonStyle(.plain)
                .position(x: 1128 + 24, y: 24 + 24)

                // MARK: - Left side: Character name + Scene image

                // Large decorative character name with gradient fill
                Text(selectedCharacter.displayName)
                    .font(.custom("SourceSerif4-Black", size: selectedCharacter.nameFontSize))
                    .foregroundStyle(nameGradient)
                    .shadow(
                        color: Color(
                            red: selectedCharacter.nameShadowColor.red,
                            green: selectedCharacter.nameShadowColor.green,
                            blue: selectedCharacter.nameShadowColor.blue,
                            opacity: selectedCharacter.nameShadowColor.opacity
                        ),
                        radius: 3, x: 2, y: 5
                    )
                    .position(
                        x: selectedCharacter == .dog ? 275 : 284,
                        y: selectedCharacter == .dog ? 177 : 177
                    )

                // Character scene image (400x400, bottom-left area)
                Image(selectedCharacter.sceneImageName)
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400, height: 400)
                    .position(x: 249, y: 400)

                // MARK: - Cloud decorations (right side)

                // Cloud & Sun (top-right area)
                Image("CloudAndSun")
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 378, height: 185)
                    .position(x: 963, y: 121)

                // Medium cloud
                Image("MediumCloud")
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 132, height: 86)
                    .position(x: 590, y: 59)

                // Small cloud
                Image("SmallCloud")
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 81, height: 38)
                    .position(x: 336, y: 121)

                // MARK: - Right side: "Select a character" + Circles + Button
                // 3 circles * 180px + 2 gaps * 32px = 604px total width

                VStack(alignment: .leading, spacing: 40) {
                    // Top section: label + circle picker
                    VStack(alignment: .leading, spacing: 24) {
                        // "Select a character" — SF Pro, 24pt, semibold (590)
                        Text("Select a character")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)

                        // Character selection circles (144x144 inner, 32px gap)
                        HStack(spacing: 32) {
                            ForEach(PetCharacter.allCases) { character in
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedCharacter = character
                                    }
                                }) {
                                    characterCircle(for: character)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    // "Continue with [Name]" button — full width matching circles row
                    Button(action: onComplete) {
                        Text("Continue with \(selectedCharacter.displayName)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 604)
                            .padding(.vertical, 24)
                            .background(Color(hex: selectedCharacter.buttonHex))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
                .frame(width: 604)
                .position(x: 858, y: 385)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    LinearGradient(
                        stops: [
                            .init(color: .white.opacity(0.3), location: 0),
                            .init(color: .black.opacity(0.3), location: 0.17),
                            .init(color: .black.opacity(0.3), location: 0.80),
                            .init(color: .white.opacity(0.3), location: 1.0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }

    // MARK: - Character circle with selection ring

    @ViewBuilder
    private func characterCircle(for character: PetCharacter) -> some View {
        let isSelected = selectedCharacter == character

        if isSelected {
            // SELECTED: 180x180 outer ring (stroke only) + 144x144 inner ring (stroke only)
            ZStack {
                // Outer ring — stroke only, no fill
                Circle()
                    .stroke(Color(hex: selectedCharacter.unselectedStrokeHex), lineWidth: 1)
                    .frame(width: 180, height: 180)

                // Inner ring — stroke only, no fill
                Circle()
                    .stroke(Color(hex: selectedCharacter.selectedStrokeHex), lineWidth: 1)
                    .frame(width: 144, height: 144)

                // Character image clipped to circle, inside the inner ring
                // .blendMode(.lighten) replaces black image background with gradient
                Image(character.circleImageName)
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
                    .blendMode(.lighten)
            }
            .frame(width: 180, height: 180)
        } else {
            // UNSELECTED: just 144x144 circle, no rings
            Image(character.circleImageName)
                .resizable()
                .interpolation(.high)
                .aspectRatio(contentMode: .fill)
                .frame(width: 144, height: 144)
                .clipShape(Circle())
                .frame(width: 180, height: 180)
        }
    }

    // MARK: - Character-specific background gradient

    private var characterGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: selectedCharacter.gradientTopHex),
                Color(hex: "000000")
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Character name text gradient

    private var nameGradient: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: Color(hex: selectedCharacter.nameGradientTopHex), location: 0),
                .init(color: .white, location: 0.75)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Color Extension for Hex

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
