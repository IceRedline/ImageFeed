//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Артем Табенский on 13.03.2025.
//

import Foundation
import WebKit

final class WebViewPresenter: WebViewPresenterProtocol {
    
    var view: WebViewViewControllerProtocol?
    private let authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        guard let request = authHelper.authURLRequest else { return }
        didUpdateProgressValue(0)
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        view?.setProgressHidden(shouldHideProgress(for: newProgressValue))
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.getCode(from: url)
    }
    
    private func logError(_ message: String) {
        print(message)
    }
}
