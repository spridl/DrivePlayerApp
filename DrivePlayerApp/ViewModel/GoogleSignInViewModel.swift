//
//  GoogleSignInViewModel.swift
//  DrivePlayerApp
//
//  Created by Тимур on 10.11.2025.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

class GoogleSignInViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var accessToken: String? = nil
    @Published var userName: String? = nil
    private var user: GIDGoogleUser? = nil
    
    init() {
        restorePreviousSignIn()
    }
    
    func signIn(presenting viewController: UIViewController) {
        let additionalScopes = ["https://www.googleapis.com/auth/drive.readonly"]
        
        GIDSignIn.sharedInstance.signIn( withPresenting: viewController ) { result, error in
            if let error = error {
                print("Error signing in: \(error)")
                return
            }
            
            guard let result = result else {
                print("No result returned from GoogleSignIn.")
                return
            }
            
            let user = result.user
            self.user = user
            
            self.updateUserState(from: result.user)
            
            print("Вход выполнен. Access Token получен")
            
            user.addScopes(additionalScopes, presenting: viewController) { result, error in
                if let error = error {
                    print("Error adding scopes: \(error)")
                    return
                }
                
                guard let result = result else {
                    print("No update user returned from GoogleSignIn.")
                    return
                }
                
                let updateUser = result.user
                
                self.user = updateUser
                self.updateUserState(from: updateUser)
                
                print("Добавлены Разрешения Drive scopes")
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        self.isSignedIn = false
        self.accessToken = nil
        self.userName = nil
        self.user = nil
        
        print("Пользователь вышел из системы")
    }
    
    func restorePreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                print("Error restoring previous sign in: \(error)")
                return
            }
            
            if let user  = user {
                print("Восстановили предыдущий вход")
                self.user = user
                self.updateUserState(from: user)
            } else {
                print("Нет сохраненной сессии")
            }
        }
    }
    func refreshAccessTokenIfNeeded(completion: @escaping (String?) -> Void) {
        guard let user = user else {
            completion(nil)
            return
        }
        
        user.refreshTokensIfNeeded { updatedUser, error in
            if let error = error {
                print("Error refreshing access token: \(error)")
                completion(nil)
                return
            }
            
            guard let updatedUser = updatedUser else {
                completion(nil)
                return
            }
            
            let newToken = updatedUser.accessToken.tokenString
            self.accessToken = newToken
            completion(newToken)
        }
    }
    
    private func updateUserState(from user: GIDGoogleUser) {
        self.isSignedIn = true
        self.accessToken = user.accessToken.tokenString
        self.userName = user.profile?.name ?? "Без имени"
        print("Пользователь вошел: \(self.userName ?? "Без имени")")
    }
}
