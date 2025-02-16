//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Артем Табенский on 28.01.2025.
//

import UIKit

class SplashViewController: UIViewController {
    
    private var storage = OAuth2TokenStorage()
    private let authSegueID = "authNotCompleted"
    private let profileService = ProfileService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let token = storage.token {
            fetchProfile(token)
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: authSegueID, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        guard let token = storage.token else { return }
        
        profileService.fetchProfile(token) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    UIBlockingProgressHUD.dismiss()
                    self.switchToTabBarController()
                    print("Profile loaded!")
                case .failure(let error):
                    print("Failed to load profile: \(error.localizedDescription)")
                    break
                }
            }
        }
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == authSegueID,
              let navigationController = segue.destination as? UINavigationController,
              let viewController = navigationController.viewControllers[0] as? AuthViewController else {
            super.prepare(for: segue, sender: sender)
            return
        }
        viewController.delegate = self
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
