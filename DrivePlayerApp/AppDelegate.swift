//
//  AppDelegate.swift
//  DrivePlayerApp
//
//  Created by Тимур on 09.11.2025.
//

import Foundation
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    
    private func getToken() -> String? {
        return Bundle.main.infoDictionary?["API_Token"] as? String
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: getToken() ?? "")
        
        return true
    }
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       return GIDSignIn.sharedInstance.handle(url)
    }
}
