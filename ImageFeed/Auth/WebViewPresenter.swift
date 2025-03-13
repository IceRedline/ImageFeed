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
    
    func viewDidLoad() {
        didUpdateProgressValue(0)
        loadAuthView()
    }
    
    func loadAuthView() {
        guard var urlComponents = URLComponents(string: Constants.unsplashAuthorizeString) else {
            logError("[loadAuthView]: URLFormationError - Не удалось создать URLComponents")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            logError("[loadAuthView]: URLFormationError - Не удалось сформировать финальный URL")
            return
        }
        
        let request = URLRequest(url: url)
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
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    private func logError(_ message: String) {
        print(message)
    }
}
