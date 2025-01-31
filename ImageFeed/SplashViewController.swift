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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let token = storage.token {
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
    }
}
