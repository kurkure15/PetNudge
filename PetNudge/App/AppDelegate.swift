import AppKit
import SwiftUI

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem!
    var popover: NSPopover!
    var onboardingWindow: NSWindow?

    let preferences = UserPreferences.shared
    let animator = MenuBarAnimator()
    lazy var scheduler = ReminderScheduler(preferences: preferences, animator: animator)
    lazy var viewModel = PetNudgeViewModel(
        preferences: preferences,
        scheduler: scheduler,
        animator: animator
    )

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide dock icon
        NSApp.setActivationPolicy(.accessory)

        // Set up status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = preferences.selectedCharacter.idleIcon
            button.action = #selector(togglePopover)
            button.target = self
        }

        // Give animator a reference to status item
        animator.statusItem = statusItem

        // Set up popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 320, height: 440)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(
            rootView: PopoverContentView()
                .environmentObject(viewModel)
                .environmentObject(preferences)
        )

        // Show onboarding if first launch, otherwise start scheduler
        if !preferences.hasCompletedOnboarding {
            showOnboarding()
        } else {
            scheduler.start()
        }
    }

    @objc func togglePopover() {
        guard let button = statusItem.button else { return }
        if popover.isShown {
            popover.performClose(nil)
        } else {
            animator.stopAnimation()
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }

    func showOnboarding() {
        let onboardingView = OnboardingContainerView(onComplete: { [weak self] in
            guard let self = self else { return }
            self.preferences.hasCompletedOnboarding = true
            self.onboardingWindow?.close()
            self.onboardingWindow = nil
            self.scheduler.start()
            self.animator.updateBaseIcon(self.preferences.selectedCharacter)
        })
        .environmentObject(preferences)

        let hostingController = NSHostingController(rootView: onboardingView)
        let window = NSWindow(contentViewController: hostingController)
        window.title = "Welcome to PetNudge"
        window.setContentSize(NSSize(width: 480, height: 560))
        window.styleMask = [.titled, .closable]
        window.center()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        self.onboardingWindow = window
    }
}
