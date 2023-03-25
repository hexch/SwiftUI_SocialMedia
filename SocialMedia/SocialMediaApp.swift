//
//  SocialMediaApp.swift
//  SocialMedia
//
//  Created by XIAOCHUAN HE on R 5/03/22.
//

import SwiftUI
import Firebase

@main
struct SocialMediaApp: App {
    init() {
        // MARK: Initialize Firebase
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
