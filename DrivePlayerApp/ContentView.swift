//
//  ContentView.swift
//  DrivePlayerApp
//
//  Created by Тимур on 09.11.2025.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct ContentView: View {
    @State private var files: [String] = []
    @State private var accessToken: String?
    
    var body: some View {
        VStack(spacing: 20) {
            if let _ = accessToken {
                Button("Загрузить список файлов") {
                    fetchFiles()
                }
                List(files, id: \.self) { file in
                    Text(file)
                }
            } else {
                GoogleSignInButton {
                    sigIn()
                }
                .padding()
            }
        }
        .padding()
    }
    
    func sigIn() {
        guard let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController})
            .first else { return }
        GIDSignIn.sharedInstance.signIn( withPresenting: rootViewController) {
            signInResult, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            
            guard let result = signInResult else { return }
            
            let token = result.user.accessToken.tokenString
            self.accessToken = token
            print("Токен получен: \(token)")
        }
    }
    
    func fetchFiles() {
        guard let token = accessToken else { return }
        
        guard let url = URL(string: "https://www.googleapis.com/drive/v3/files") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка сети: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                if let filesArray = json?["files"] as? [[String: Any]] {
                    DispatchQueue.main.async {
                        self.files = filesArray.compactMap { $0["name"] as? String }
                    }
                }
            } catch {
                print("Ошибка JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}


