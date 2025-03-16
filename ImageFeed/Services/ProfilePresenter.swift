//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Артем Табенский on 13.03.2025.
//

import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let storage = OAuth2TokenStorage()
    
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        print("Profile presenter загружен!")
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.view?.updateAvatar(with: configureURLForAvatar())
        }
        view?.updateAvatar(with: configureURLForAvatar())
        updateProfileDetails()
        print("данные профиля и аватарка загружены!")
    }
    
    private func updateProfileDetails() {
        guard let profile = ProfileService.shared.profile else { return }
        view?.updateProfileDetails(with: profile)
    }
    
    func configureURLForAvatar() -> URL? {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return nil }
        return url
    }
    
    func logout() {
        ProfileLogoutService.shared.logout()
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
    }
}
