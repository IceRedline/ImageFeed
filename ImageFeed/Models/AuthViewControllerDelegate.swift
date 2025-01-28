//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Артем Табенский on 28.01.2025.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
