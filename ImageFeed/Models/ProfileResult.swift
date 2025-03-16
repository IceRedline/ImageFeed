//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Артем Табенский on 02.02.2025.
//

import Foundation

public struct ProfileResult: Codable {
    let username: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}
