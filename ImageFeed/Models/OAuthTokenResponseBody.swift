//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Артем Табенский on 27.01.2025.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    let error: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
        case error
    }
}
