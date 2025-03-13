//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Артем Табенский on 13.03.2025.
//

import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
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
    
    private func logError(_ message: String) {
        print(message)
    }
}
