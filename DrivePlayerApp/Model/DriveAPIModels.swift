//
//  DriveAPIModels.swift
//  DrivePlayerApp
//
//  Created by Тимур on 10.11.2025.
//

import Foundation

struct FilesListResponse: Codable {
    let files: [DriveAPIFile]
}

struct DriveAPIFile: Codable {
    let id: String
    let name: String
    let mimeType: String?
}
