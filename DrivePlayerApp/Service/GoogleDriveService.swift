//
//  GoogleDriveService.swift
//  DrivePlayerApp
//
//  Created by Тимур on 09.11.2025.
//

import Foundation
import GoogleSignIn

final class GoogleDriveService {
    
    func fetchFiles(accessToken: String, completion: @escaping (Result<[DriveFile], Error>) -> Void) {
        let queryValue = "(mimeType='audio/mpeg' or mimeType='audio/wav' or mimeType='audio/mp4' or mimeType='audio/flac')"
        
        guard var components = URLComponents(string: "https://www.googleapis.com/drive/v3/files") else { return }
        components.queryItems = [
            URLQueryItem(name: "q", value: queryValue),
            URLQueryItem(name: "pageSize", value: "20"),
            URLQueryItem(name: "fields", value: "files(id,name,mimeType)")
        ]
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("ошибка \(error.localizedDescription)")
                return
            }
            
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                let error = NSError(
                    domain: "GoogleDriveService",
                    code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode)"]
                )
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.success([]))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let filesResponse = try decoder.decode(FilesListResponse.self, from: data)
                let driveFiles = filesResponse.files.map {
                    DriveFile(id: $0.id, name: $0.name, mimeType: $0.mimeType ?? "")
                }
                completion(.success(driveFiles))
            } catch {
                completion(.failure(error))
                print("ошибка при декодировании")
            }
        }
            task.resume()
    }
    
    func fileDownloadURL(for fileID: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.googleapis.com"
        components.path = "/drive/v3/files/\(fileID)"
        
        components.queryItems = [
            URLQueryItem(name: "alt", value: "media"),
            ]
        return components.url
    }
    

}
