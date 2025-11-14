//
//  GoogleUser.swift
//  DrivePlayerApp
//
//  Created by Тимур on 09.11.2025.
//

import Foundation

struct GoogleUser {
    let id: String
    let name: String
    let email: String
    let profileImageURL: URL?
}

struct GoogleAuthResult {
    let user: GoogleUser
    let accessToken: String
}
