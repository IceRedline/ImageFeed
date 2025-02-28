//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Артем Табенский on 28.02.2025.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt, updatedAt: Date
    let width, height: Int
    let color, blurHash: String
    let likes: Int
    let likedByUser: Bool
    let description: String
    let user: UserResult
    let urls: UrlsResult

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width, height, color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case description
        case user
        case urls
    }
}
