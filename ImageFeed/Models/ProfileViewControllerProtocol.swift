//
//  ProfileViewDelegate.swift
//  ImageFeed
//
//  Created by Артем Табенский on 13.03.2025.
//

import Foundation

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar(with url: URL?)
    func updateProfileDetails(with profile: Profile)
}
