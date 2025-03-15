//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Артем Табенский on 14.03.2025.
//

import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var didCallLogout: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        
        view?.updateAvatar(with: nil)
        updateProfileDetails()
    }
    
    func updateProfileDetails() {
        let jsonData: Data = """
        {
            "username": "test_user",
            "first_name": "John",
            "last_name": "Doe",
            "bio": "This is a bio."
        }
        """.data(using: .utf8)!

        do {
            let decoder = JSONDecoder()
            let profileResult = try decoder.decode(ProfileResult.self, from: jsonData)
            let profile = Profile(profileResult: profileResult)
            view?.updateProfileDetails(with: Profile(profileResult: profileResult))
        } catch {
            print("Ошибка декодирования: \(error)")
        }
    }
    
    func logout() {
        didCallLogout = true
    }
    
}
