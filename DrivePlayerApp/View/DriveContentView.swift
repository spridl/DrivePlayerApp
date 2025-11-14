//
//  DriveContentView.swift
//  DrivePlayerApp
//
//  Created by Тимур on 10.11.2025.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct DriveContentView: View {
    @StateObject private var viewModel = GoogleSignInViewModel()
    private let driveService = GoogleDriveService()
    
    @State private var files:[DriveFile] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            if viewModel.isSignedIn {
                Text("Привет \(viewModel.userName ?? "User")!")
                    .font(.headline)
                
                DriveMusicView(viewModel: DriveViewModel(accessToken: viewModel.accessToken ?? "", driveService: GoogleDriveService(), playerService: AudioPlayerService()))
                
//                Button("Загрузить файлы из Google Drive") {
//                    loadDriveFiles()
//                }
//                
//                if isLoading {
//                    ProgressView()
//                }
//                
//                List(files, id: \.self) { file in
//                    Text(file.name)
//                }
                
                Button("Выйти") {
                    viewModel.signOut()
                }
                .foregroundStyle(.red)
            } else {
                GoogleSignInButton {
                    if let rootVC = UIApplication.shared.connectedScenes
                        .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
                        .first {
                        viewModel.signIn(presenting: rootVC)
                    }
                }
                .frame(height: 50)
                .padding()
            }
        }
        .padding()
    }
    
    private func loadDriveFiles() {
        guard let token = viewModel.accessToken else { return }
        isLoading = true
        viewModel.refreshAccessTokenIfNeeded { newToken in
            let activeToken = newToken ?? token
            driveService.fetchFiles(accessToken: activeToken) { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let fileNames):
                        self.files = fileNames
                    case .failure(let error):
                        print("Error fetching files: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}


#Preview {
    DriveContentView()
}
