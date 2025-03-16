//
//  WebViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Артем Табенский on 13.03.2025.
//

import ImageFeed
import UIKit

final class WebViewControllerSpy: UIViewController & WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var loadRequestCalled = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
    
    
}
