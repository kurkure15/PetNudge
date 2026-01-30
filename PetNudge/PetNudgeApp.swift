//
//  PetNudgeApp.swift
//  PetNudge
//
//  Created by Ankur Yadav on 1/30/26.
//

import SwiftUI

@main
struct PetNudgeApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
