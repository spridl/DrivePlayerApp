//
//  DriveViewModel.swift
//  DrivePlayerApp
//
//  Created by Тимур on 09.11.2025.
//

import SwiftUI

@MainActor
final class DriveViewModel: ObservableObject {
    @Published var files: [DriveFile] = []
    @Published var isLoading = false
    @Published var currentTrack: DriveFile?
    @Published var isPlaying: Bool = false
    
    private let driveService: GoogleDriveService
    private let playerService: AudioPlayerService
    private let accessToken: String
    
    init(accessToken: String, driveService: GoogleDriveService, playerService: AudioPlayerService) {
        self.accessToken = accessToken
        self.driveService = driveService
        self.playerService = playerService
    }
    
    func loadMusic() {
        isLoading = true
        driveService.fetchFiles(accessToken: accessToken) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let files):
                    self?.files = files
                case .failure(let error):
                    print("Ошибка загрузки файлов: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    func play(file: DriveFile) {
        guard let url = driveService.fileDownloadURL(for: file.id) else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        guard let authURL = request.url else { return }
        
        playerService.play(url: authURL)
        currentTrack = file
        isLoading = true
    }
    
    func downloadAndPlay(file: DriveFile, fileID: String) {
        if file.id == fileID {
            playerService.playResume()
        } else {
            guard let url = driveService.fileDownloadURL(for: file.id) else { return }
            
            var request = URLRequest(url: url)
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.downloadTask(with: request) { tempURL, response, error in
                guard let tempURL = tempURL else { return }
                let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(file.name)
                try? FileManager.default.moveItem(at: tempURL, to: localURL)
                
                DispatchQueue.main.async {
                    self.playerService.play(url: localURL)
                    self.currentTrack = file
                    self.isPlaying = true
    //                self.isLoading = true
                }
            }.resume()
        }

    }
    
    func pause() {
        playerService.pause()
        isPlaying = false
    }
    
    func stop() {
        playerService.stop()
        isPlaying = false
    }
    
    
    
    
}
//    @Published var user: GoogleUser?
//    @Published var files: [DriveFile] = []
//    @Published var isLoading = false
//    
//    private let signInService = GoogleSignInService.shared
//    private let driveService = GoogleDriveService()
//    var accessToken: String?
//    
//    func signIn(presenting: UIViewController) {
//        isLoading = true
//        signInService.signIn(presenting: presenting) { [weak self] result in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//                switch result {
//                case .success(let authResult):
//                    self?.user = authResult.user
//                    self?.accessToken = authResult.accessToken
//                case .failure(let error):
//                    print("SignIn error: \(error)")
//                }
//            }
//        }
//    }
//    
//    func fetchDriveFiles() {
//        guard let token = accessToken else { return }
//        isLoading = true
//        driveService.fetchFiles(accessToken: token) { [weak self] result in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//                switch result {
//                case .success(let files):
//                    self?.files = files
//                case .failure(let error):
//                    print("FetchFiles error: \(error)")
//                }
//            }
//        }
//    }
//}
