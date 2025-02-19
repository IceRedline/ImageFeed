//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Артем Табенский on 08.01.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let profilePicture: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "profilepic")
        view.image = image
        return view
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()
    
    private let userNickname: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let userDescription: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: nil
        )
        button.tintColor = .ypRed
        return button
    }()
    
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews()
        loadConstraints()
        updateProfileDetails(with: profileService.profile!)
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            //self.updateAvatar
        }
        updateAvatar()
    }
    
    private func loadViews() {
        [profilePicture, userName, userNickname, userDescription, exitButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func loadConstraints() {
        NSLayoutConstraint.activate([
            profilePicture.widthAnchor.constraint(equalToConstant: 70),
            profilePicture.heightAnchor.constraint(equalToConstant: 70),
            profilePicture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profilePicture.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            userName.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 8),
            userName.leadingAnchor.constraint(equalTo: profilePicture.leadingAnchor),
            userNickname.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8),
            userNickname.leadingAnchor.constraint(equalTo: profilePicture.leadingAnchor),
            userDescription.topAnchor.constraint(equalTo: userNickname.bottomAnchor, constant: 8),
            userDescription.leadingAnchor.constraint(equalTo: profilePicture.leadingAnchor),
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            exitButton.centerYAnchor.constraint(equalTo: profilePicture.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func updateProfileDetails(with profile: Profile) {
        userName.text = profile.name
        userNickname.text = profile.loginName
        userDescription.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
    }
}
