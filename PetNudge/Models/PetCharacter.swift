import AppKit
import SwiftUI

enum PetCharacter: String, Codable, CaseIterable, Identifiable {
    case cat
    case dog
    case rabbit
    case hamster
    case parrot
    case fish

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .cat:     return "🐱"
        case .dog:     return "🐶"
        case .rabbit:  return "🐰"
        case .hamster: return "🐹"
        case .parrot:  return "🦜"
        case .fish:    return "🐠"
        }
    }

    var displayName: String {
        switch self {
        case .cat:     return "Cat"
        case .dog:     return "Dog"
        case .rabbit:  return "Rabbit"
        case .hamster: return "Hamster"
        case .parrot:  return "Parrot"
        case .fish:    return "Fish"
        }
    }

    // MARK: - SF Symbol placeholders (replace with custom assets later)

    var sfSymbol: String {
        switch self {
        case .cat:     return "cat.fill"
        case .dog:     return "dog.fill"
        case .rabbit:  return "hare.fill"
        case .hamster: return "pawprint.fill"
        case .parrot:  return "bird.fill"
        case .fish:    return "fish.fill"
        }
    }

    // MARK: - Menu Bar Icons (NSImage)
    // To replace with custom assets:
    //   1. Add images to Assets.xcassets named like "cat-idle", "cat-watching", "cat-nudge-1", "cat-nudge-2"
    //   2. Replace the SF Symbol fallback with: NSImage(named: "\(rawValue)-idle")

    /// Icon shown in menu bar when no reminders are near
    var idleIcon: NSImage {
        menuBarImage(systemName: sfSymbolForState(.idle))
    }

    /// Icon shown ~5 min before a reminder fires
    var watchingIcon: NSImage {
        menuBarImage(systemName: sfSymbolForState(.watching))
    }

    /// Frames shown when a reminder fires (alternating animation)
    var nudgeFrames: [NSImage] {
        [
            menuBarImage(systemName: sfSymbolForState(.nudge1)),
            menuBarImage(systemName: sfSymbolForState(.nudge2))
        ]
    }

    enum IconState {
        case idle, watching, nudge1, nudge2
    }

    private func sfSymbolForState(_ state: IconState) -> String {
        switch (self, state) {
        case (.cat, .idle):       return "cat"
        case (.cat, .watching):   return "cat.fill"
        case (.cat, .nudge1):     return "cat.fill"
        case (.cat, .nudge2):     return "exclamationmark.bubble.fill"

        case (.dog, .idle):       return "dog"
        case (.dog, .watching):   return "dog.fill"
        case (.dog, .nudge1):     return "dog.fill"
        case (.dog, .nudge2):     return "exclamationmark.bubble.fill"

        case (.rabbit, .idle):    return "hare"
        case (.rabbit, .watching): return "hare.fill"
        case (.rabbit, .nudge1):  return "hare.fill"
        case (.rabbit, .nudge2):  return "exclamationmark.bubble.fill"

        case (.hamster, .idle):   return "pawprint"
        case (.hamster, .watching): return "pawprint.fill"
        case (.hamster, .nudge1): return "pawprint.fill"
        case (.hamster, .nudge2): return "exclamationmark.bubble.fill"

        case (.parrot, .idle):    return "bird"
        case (.parrot, .watching): return "bird.fill"
        case (.parrot, .nudge1):  return "bird.fill"
        case (.parrot, .nudge2):  return "exclamationmark.bubble.fill"

        case (.fish, .idle):      return "fish"
        case (.fish, .watching):  return "fish.fill"
        case (.fish, .nudge1):    return "fish.fill"
        case (.fish, .nudge2):    return "exclamationmark.bubble.fill"
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
        // Fallback: render emoji into an image
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
