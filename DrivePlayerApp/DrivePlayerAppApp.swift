//
//  DrivePlayerAppApp.swift
//  DrivePlayerApp
//
//  Created by Тимур on 09.11.2025.
//

import SwiftUI
import GoogleSignIn

@main
struct DriveMusicPlayAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            DriveContentView()
        }
    }
}
