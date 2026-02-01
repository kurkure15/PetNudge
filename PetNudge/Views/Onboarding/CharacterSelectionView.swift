import SwiftUI

struct CharacterSelectionView: View {
    @Binding var selectedCharacter: PetCharacter
    let onComplete: () -> Void

    var body: some View {
        ZStack {
            // Full dark gradient background
            characterGradient
                .ignoresSafeArea()

            // Main layout
            VStack(spacing: 0) {

                // Top bar: Settings (left) and Close (right)
                HStack {
                    Button(action: {}) {
                        Image("ic_Setting")
                            .resizable()
                            .interpolation(.high)
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Button(action: {}) {
                        Image("ic_cross")
                            .resizable()
                            .interpolation(.high)
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Content area
                HStack(spacing: 0) {

                    // LEFT SIDE: Large name + character scene
                    ZStack(alignment: .topLeading) {
                        // Character scene image (bottom-left)
                        Image(selectedCharacter.sceneImageName)
                            .resizable()
                            .interpolation(.high)
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 420)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                            .padding(.leading, 20)
                            .padding(.bottom, 20)

                        // Large decorative character name (160px, serif)
                        Text(selectedCharacter.displayName)
                            .font(.custom("Source Serif 4", size: 160).weight(.black))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                            .padding(.leading, 32)
                            .padding(.top, 0)
                    }
                    .frame(maxWidth: .infinity)

                    // RIGHT SIDE: Clouds, "Select a character", thumbnails
                    VStack(alignment: .center, spacing: 0) {
                        // Cloud & Sun decorative (top-right)
                        HStack(spacing: -20) {
                            Image("SmallCloud")
                                .resizable()
                                .interpolation(.high)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 40)

                            Image("CloudAndSun")
                                .resizable()
                                .interpolation(.high)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 80)
                        }
                        .padding(.top, 10)

                        // Medium cloud (separate, offset right)
                        HStack {
                            Spacer()
                            Image("MediumCloud")
                                .resizable()
                                .interpolation(.high)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 60)
                        }
                        .padding(.trailing, -10)
                        .padding(.top, -10)

                        Spacer()

                        // "Select a character" text - Inter font, 24px
                        Text("Select a character")
                            .font(.system(size: 24, weight: .semibold, design: .default))
                            .foregroundColor(.white)
                            .padding(.bottom, 24)

                        // Character selection thumbnails (circle assets)
                        HStack(spacing: 16) {
                            ForEach(PetCharacter.allCases) { character in
                                Button(action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedCharacter = character
                                    }
                                }) {
                                    // Use Selected image if selected, Circle image if not
                                    Image(selectedCharacter == character
                                          ? "\(character.assetPrefix)-Selected"
                                          : "\(character.assetPrefix)-Circle")
                                        .resizable()
                                        .interpolation(.high)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .scaleEffect(selectedCharacter == character ? 1.08 : 1.0)
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        Spacer()
                    }
                    .frame(width: 340)
                    .padding(.trailing, 40)
                }

                // Bottom: "Continue with [Name]" button — full width
                Button(action: onComplete) {
                    Text("Continue with \(selectedCharacter.displayName)")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(characterButtonColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }

    // MARK: - Character-specific dark gradients

    private var characterGradient: LinearGradient {
        switch selectedCharacter {
        case .dog: // Blue - from Figma: #051184 → #000
            return LinearGradient(
                colors: [
                    Color(hex: "051184"),
                    Color(hex: "000000")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .cat: // Budgie - warm dark brown/amber
            return LinearGradient(
                colors: [
                    Color(hex: "5C3A0E"),
                    Color(hex: "000000")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .redPanda: // Pabu - dark emerald green
            return LinearGradient(
                colors: [
                    Color(hex: "0A5C3A"),
                    Color(hex: "000000")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    // MARK: - Character-specific button colors

    private var characterButtonColor: Color {
        switch selectedCharacter {
        case .dog:
            return Color(hex: "1A2E8A")
        case .cat:
            return Color(hex: "7A5020")
        case .redPanda:
            return Color(hex: "1A7A4A")
        }
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
