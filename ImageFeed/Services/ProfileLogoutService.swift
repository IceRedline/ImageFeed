//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Артем Табенский on 05.03.2025.
//

import Foundation
import WebKit
import SwiftKeychainWrapper

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        KeychainWrapper.standard.remove(forKey: KeychainKey.bearerToken.rawValue)
        cleanCookies()
        cleanProfile()
        cleanImages()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanProfile() {
        ProfileService.shared.profile = nil
        ProfileImageService.shared.avatarURL = nil
    }
    
    private func cleanImages() {
        ImagesListService().photos = []
    }
}
