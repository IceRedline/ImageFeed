//
//  UserResult.swift
//  ImageFeed
//
//  Created by Артем Табенский on 23.02.2025.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
