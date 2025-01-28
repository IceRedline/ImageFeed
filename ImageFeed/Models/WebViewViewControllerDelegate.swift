//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Артем Табенский on 23.01.2025.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
