//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Артем Табенский on 13.03.2025.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
}
