//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Артем Табенский on 27.01.2025.
//

import Foundation

final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    private let tokenKey = "BearerToken"

    var token: String? {
        get {
            return userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.setValue(newValue, forKey: tokenKey)
        }
    }
}
