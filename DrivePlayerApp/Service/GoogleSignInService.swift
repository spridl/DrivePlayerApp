//
//  GoogleSignInService.swift
//  DrivePlayerApp
//
//  Created by Тимур on 09.11.2025.
//

import Foundation
import GoogleSignIn

final class GoogleSignInService {
    static let shared = GoogleSignInService()
    
    private init() {}
    
    private func getToken() -> String? {
        return Bundle.main.infoDictionary?["API_Token"] as? String
    }
    
    func signIn(presenting: UIViewController, completion: @escaping(Result<GoogleAuthResult, Error>) -> Void) {
        
        let config = GIDConfiguration(clientID: getToken() ?? "")
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presenting,
            hint: nil,
            additionalScopes: ["https://www.googleapis.com/auth/drive.readonly"]
        )
        {
            result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else { return }
            
            let accessToken = user.accessToken.tokenString
            
            let googleUser = GoogleUser(
                id: user.userID ?? "",
                name: user.profile?.name ?? "",
                email: user.profile?.email ?? "",
                profileImageURL: user.profile?.imageURL(withDimension: 100)
            )
            
            completion(.success(GoogleAuthResult(user: googleUser, accessToken: accessToken)))
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
