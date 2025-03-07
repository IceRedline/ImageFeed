//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Артем Табенский on 28.02.2025.
//

import Foundation

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
