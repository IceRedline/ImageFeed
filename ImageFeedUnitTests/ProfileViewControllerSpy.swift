//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Артем Табенский on 14.03.2025.
//

import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol?
    var viewDidLoadCalled: Bool = false
    var profileDetailsUpdated: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        presenter?.viewDidLoad()
    }
    
    func configure(_ presenter: any ImageFeed.ProfilePresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    func updateAvatar(with url: URL?) {
    }
    
    func updateProfileDetails(with profile: ImageFeed.Profile) {
        profileDetailsUpdated = true
    }
    
    func exitButtonTapped() {
        presenter?.logout()
    }
}
