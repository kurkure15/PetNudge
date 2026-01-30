import AppKit
import Combine
import Foundation

@MainActor
final class MenuBarAnimator: ObservableObject {

    weak var statusItem: NSStatusItem?
    @Published var isAnimating: Bool = false

    private var animationTimer: Timer?
    private var animationStep: Int = 0
    private var currentCharacter: PetCharacter = .cat

    func startAnimation(for reminder: Reminder) {
        guard let button = statusItem?.button else { return }

        isAnimating = true
        animationStep = 0

        let frames = currentCharacter.nudgeFrames

        animationTimer?.invalidate()
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { @Sendable [weak self] _ in
            Task { @MainActor in
                guard let self = self, let btn = self.statusItem?.button else { return }
                self.animationStep += 1

                let frameIndex = self.animationStep % frames.count
                btn.image = frames[frameIndex]

                // Stop after ~6 seconds (10 toggles)
                if self.animationStep >= 10 {
                    self.stopAnimation()
                }
            }
        }

        // Show first nudge frame immediately
        button.image = frames.isEmpty ? currentCharacter.idleIcon : frames[0]
    }

    func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
        animationStep = 0
        isAnimating = false

        // Restore idle icon
        statusItem?.button?.image = currentCharacter.idleIcon
    }

    func updateBaseIcon(_ character: PetCharacter) {
        currentCharacter = character
        if !isAnimating {
            statusItem?.button?.image = character.idleIcon
        }
    }

    /// Call when a reminder is approaching (within 5 min) to show the "watching" state
    func showWatchingState() {
        guard !isAnimating else { return }
        statusItem?.button?.image = currentCharacter.watchingIcon
    }

    /// Return to idle state from watching
    func showIdleState() {
        guard !isAnimating else { return }
        statusItem?.button?.image = currentCharacter.idleIcon
    }
}
