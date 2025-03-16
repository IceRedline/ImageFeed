//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Артем Табенский on 27.01.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let keyChain = KeychainWrapper.standard
    private let tokenKey = Constants.bearerToken

    var token: String? {
        get {
            return keyChain.string(forKey: tokenKey)
        }
        set {
            keyChain.set(newValue ?? "no token", forKey: tokenKey)
        }
    }
}
