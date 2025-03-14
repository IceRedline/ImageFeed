//
//  ProfileViewDelegate.swift
//  ImageFeed
//
//  Created by Артем Табенский on 13.03.2025.
//

import Foundation

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func configure(_ presenter: ProfilePresenterProtocol)
    func updateAvatar(with url: URL?)
    func updateProfileDetails(with profile: Profile)
    func exitButtonTapped()
}
