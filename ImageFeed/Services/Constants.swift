//
//  Constants.swift
//  ImageFeed
//
//  Created by Артем Табенский on 16.03.2025.
//

import Foundation
import SwiftKeychainWrapper

enum Constants {
    static let accessKey = "kyAYGFYZT1Je1CaiT648MRU9e-Z3g8SX_sCx1kqCfNI"
    static let secretKey = "ilZ4rBGwC2utS4vJZ2zGLdLDhF1N3CK6Kw4mEAIpzi4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL = {
        guard let url = URL(string: "https://api.unsplash.com/") else {
            print("[Constants]: fatalError - failed to create base URL")
            fatalError("Invalid base URL for Unsplash API")
        }
        return url
    }()
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let bearerToken = "BearerToken"
}

enum KeychainKey: KeychainWrapper.Key {
    case bearerToken
}
