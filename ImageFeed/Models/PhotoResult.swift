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
    var likedByUser: Bool
    let description: String?
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dateFormatter = ISO8601DateFormatter()
        
        if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt),
           let updatedAtString = try container.decodeIfPresent(String.self, forKey: .updatedAt) {
            self.createdAt = dateFormatter.date(from: createdAtString) ?? Date()
            self.updatedAt = dateFormatter.date(from: updatedAtString) ?? Date()
        } else {
            self.createdAt = Date()
            self.updatedAt = Date()
        }
        
        self.id = try container.decode(String.self, forKey: .id)
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
        self.color = try container.decode(String.self, forKey: .color)
        self.blurHash = try container.decode(String.self, forKey: .blurHash)
        self.likes = try container.decode(Int.self, forKey: .likes)
        self.likedByUser = try container.decode(Bool.self, forKey: .likedByUser)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.user = try container.decode(UserResult.self, forKey: .user)
        self.urls = try container.decode(UrlsResult.self, forKey: .urls)
    }
}
