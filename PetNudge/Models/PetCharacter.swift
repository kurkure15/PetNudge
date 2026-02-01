import AppKit
import SwiftUI

enum PetCharacter: String, Codable, CaseIterable, Identifiable {
    case cat
    case dog
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
