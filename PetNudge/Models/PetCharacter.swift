import AppKit
import SwiftUI

enum PetCharacter: String, Codable, CaseIterable, Identifiable {
    case dog
    case cat
    case redPanda

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .cat:      return "🐱"
        case .dog:      return "🐶"
        case .redPanda: return "🦊"
        }
    }

    var displayName: String {
        switch self {
        case .cat:      return "Budgie"
        case .dog:      return "Blue"
        case .redPanda: return "Pabu"
        }
    }

    // MARK: - SF Symbol fallbacks

    var sfSymbol: String {
        switch self {
        case .cat:      return "cat.fill"
        case .dog:      return "dog.fill"
        case .redPanda: return "pawprint.fill"
        }
    }

    // MARK: - Custom Asset Names
    // Naming convention: "{prefix}-Idle", "{prefix}-Watching", "{prefix}-Nudge1", "{prefix}-Nudge2"

    var assetPrefix: String {
        switch self {
        case .cat:      return "Budgie"
        case .dog:      return "Blue"
        case .redPanda: return "Pabu"
        }
    }

    // MARK: - Selection Screen Assets

    var sceneImageName: String {
        return "\(assetPrefix)-Scene"
    }

    var circleImageName: String {
        return "\(assetPrefix)-Circle"
    }

    var selectedImageName: String {
        return "\(assetPrefix)-Selected"
    }

    // MARK: - Design Tokens (from Figma)

    /// Character name font size — Blue is 208pt (shorter name), others 160pt
    var nameFontSize: CGFloat {
        switch self {
        case .dog:      return 208
        case .cat:      return 160
        case .redPanda: return 160
        }
    }

    /// Background gradient top color for character selection (Step 0)
    var gradientTopHex: String {
        switch self {
        case .dog:      return "051184"
        case .cat:      return "5E3307"
        case .redPanda: return "0F6A43"
        }
    }

    /// Background gradient top color for first reminder (Step 1) — darker variant
    var step1GradientTopHex: String {
        switch self {
        case .dog:      return "061937"
        case .cat:      return "5E3307"
        case .redPanda: return "0F6A43"
        }
    }

    /// Button background color (matches gradient top)
    var buttonHex: String { gradientTopHex }

    /// Accent color for editable text on Step 1
    var accentHex: String {
        switch self {
        case .dog:      return "5B97F7"
        case .cat:      return "FFB260"
        case .redPanda: return "60DCA6"
        }
    }

    /// Name text gradient — top color
    var nameGradientTopHex: String {
        switch self {
        case .dog:      return "AFCDFF"
        case .cat:      return "5E3307"
        case .redPanda: return "0F6A43"
        }
    }

    /// Name text shadow color
    var nameShadowColor: (red: Double, green: Double, blue: Double, opacity: Double) {
        switch self {
        case .dog:      return (198/255, 219/255, 252/255, 1.0)
        case .cat:      return (94/255, 51/255, 7/255, 0.3)
        case .redPanda: return (15/255, 106/255, 67/255, 0.3)
        }
    }

    /// Selected circle border stroke color
    var selectedStrokeHex: String {
        switch self {
        case .dog:      return "6B74BF"
        case .cat:      return "A15D18"
        case .redPanda: return "0C804E"
        }
    }

    /// Unselected circle border stroke color
    var unselectedStrokeHex: String {
        switch self {
        case .dog:      return "2C3056"
        case .cat:      return "3C2309"
        case .redPanda: return "073D22"
        }
    }

    // MARK: - Menu Bar Icons (NSImage)

    /// Icon shown in menu bar when no reminders are near
    var idleIcon: NSImage {
        if let image = NSImage(named: "\(assetPrefix)-Idle") {
            image.isTemplate = false
            return image
        }
        return menuBarImage(systemName: sfSymbolForState(.idle))
    }

    /// Icon shown ~5 min before a reminder fires
    var watchingIcon: NSImage {
        if let image = NSImage(named: "\(assetPrefix)-Watching") {
            image.isTemplate = false
            return image
        }
        return menuBarImage(systemName: sfSymbolForState(.watching))
    }

    /// Frames shown when a reminder fires (alternating animation)
    var nudgeFrames: [NSImage] {
        let frame1 = NSImage(named: "\(assetPrefix)-Nudge1")
        let frame2 = NSImage(named: "\(assetPrefix)-Nudge2")
        if let f1 = frame1, let f2 = frame2 {
            f1.isTemplate = false
            f2.isTemplate = false
            return [f1, f2]
        }
        return [
            menuBarImage(systemName: sfSymbolForState(.nudge1)),
            menuBarImage(systemName: sfSymbolForState(.nudge2))
        ]
    }

    enum IconState {
        case idle, watching, nudge1, nudge2
    }

    private func sfSymbolForState(_ state: IconState) -> String {
        switch (self, state) {
        case (.cat, .idle):        return "cat"
        case (.cat, .watching):    return "cat.fill"
        case (.cat, .nudge1):      return "cat.fill"
        case (.cat, .nudge2):      return "exclamationmark.bubble.fill"

        case (.dog, .idle):        return "dog"
        case (.dog, .watching):    return "dog.fill"
        case (.dog, .nudge1):      return "dog.fill"
        case (.dog, .nudge2):      return "exclamationmark.bubble.fill"

        case (.redPanda, .idle):   return "pawprint"
        case (.redPanda, .watching): return "pawprint.fill"
        case (.redPanda, .nudge1): return "pawprint.fill"
        case (.redPanda, .nudge2): return "exclamationmark.bubble.fill"
        }
    }

    /// Creates a properly sized NSImage for the menu bar (18x18pt)
    private func menuBarImage(systemName: String) -> NSImage {
        let config = NSImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        if let image = NSImage(systemSymbolName: systemName, accessibilityDescription: displayName) {
            let configured = image.withSymbolConfiguration(config) ?? image
            configured.isTemplate = true
            return configured
        }
        return emojiImage(emoji, size: NSSize(width: 18, height: 18))
    }

    /// Renders an emoji string into an NSImage (fallback)
    private func emojiImage(_ emoji: String, size: NSSize) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 14)
        ]
        let str = NSAttributedString(string: emoji, attributes: attributes)
        let strSize = str.size()
        let point = NSPoint(
            x: (size.width - strSize.width) / 2,
            y: (size.height - strSize.height) / 2
        )
        str.draw(at: point)
        image.unlockFocus()
        return image
    }
}
