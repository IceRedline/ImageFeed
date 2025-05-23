//
//  Profile.swift
//  ImageFeed
//
//  Created by Артем Табенский on 02.02.2025.
//

import Foundation

public struct Profile {
    let profileResult: ProfileResult
    
    var userName: String? {
        return profileResult.username
    }
    
    var name: String {
        return (profileResult.firstName ?? "") + " " + (profileResult.lastName ?? "")
    }
    
    var loginName: String {
        return "@" + (profileResult.username ?? "")
    }
    
    var bio: String? {
        return profileResult.bio
    }
    
    public init(profileResult: ProfileResult) {
        self.profileResult = profileResult
    }
}
