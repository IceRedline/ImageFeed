//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Артем Табенский on 23.01.2025.
//

import UIKit
@preconcurrency import WebKit

enum WebViewConstants {
    static let unsplashAuthorizeString = "https://unsplash.com/oauth/authorize"
}

class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    
    private var estimatedProgressObservaiton: NSKeyValueObservation?
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        loadAuthView()
        
        estimatedProgressObservaiton = webView.observe(
            \.estimatedProgress,
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             }
        )
    }
    
    private func updateProgress() {
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeString) else {
            print("Ссылка не была сформирована")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("Ссылка с запросами не была сформирована")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            print("Не удалось получить code из url")
            return nil
        }
    }
}
