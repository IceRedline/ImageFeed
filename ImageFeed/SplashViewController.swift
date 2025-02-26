//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Артем Табенский on 28.01.2025.
//

import UIKit
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    
    private let logoImage = {
        let view = UIImageView()
        view.image = UIImage(named: "yp_logo")
        return view
    }()
    
    private var storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //KeychainWrapper.standard.remove(forKey: "BearerToken")
        view.backgroundColor = .ypBlack
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImage)
        loadConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            profileService.fetchProfile(token) { result in
                switch result {
                case .success(let profile):
                    DispatchQueue.main.async {
                        print("Профиль загружен: \(profile)")
                        ProfileImageService.shared.fetchProfileImageURL(username: profile.userName!) { _ in }
                        self.switchToTabBarController()
                    }
                case .failure(let error):
                    print("Ошибка загрузки профиля: \(error)")
                }
            }
        } else {
            if let authVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController {
                authVC.delegate = self
                authVC.modalPresentationStyle = .fullScreen
                present(authVC, animated: true)
            }
        }
    }
    
    // MARK: - Methods
    
    private func loadConstraints() {
        NSLayoutConstraint.activate([
            logoImage.widthAnchor.constraint(equalToConstant: 75),
            logoImage.heightAnchor.constraint(equalToConstant: 77.68),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
        //window.makeKeyAndVisible()
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        guard let token = storage.token else { return }
        
        profileService.fetchProfile(token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.switchToTabBarController()
                    print("Profile loaded!")
                case .failure(let error):
                    print("Failed to load profile: \(error.localizedDescription)")
                    break
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        switchToTabBarController()
        
        guard let token = storage.token else { return }
        fetchProfile(token)
    }
}
