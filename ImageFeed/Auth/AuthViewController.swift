//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Артем Табенский on 23.01.2025.
//

import UIKit

class AuthViewController: UIViewController {
    
    private let segueID = "ShowWebView"
    private let oauth2service = OAuth2Service.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Ошибка при переходе \(segueID)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configureBackButton() {
        let backButton = UIImage(named: "backward")
        navigationController?.navigationBar.backIndicatorImage = backButton
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) {
            self.oauth2service.fetchOAuthToken(code: code) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let token):
                        print("Token accepted: \(token)")
                        self.delegate?.didAuthenticate(self)
                    case .failure(let error):
                        print("Failed to fetch token: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
