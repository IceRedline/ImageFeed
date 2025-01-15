//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Артем Табенский on 08.01.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var profilePicture = UIImageView()
    private var userName = UILabel()
    private var userNickname = UILabel()
    private var userDescription = UILabel()
    private var exitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViews()
        loadViews()
        loadConstraints()
        
    }
    
    private func configViews() {
        if let picture = UIImage(named: "profilepic") {
            profilePicture.image = picture
        }
        
        userName.text = "Екатерина Новикова"
        userName.textColor = .ypWhite
        userName.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        userNickname.text = "@ekaterina_nov"
        userNickname.textColor = .ypGray
        userNickname.font = UIFont.systemFont(ofSize: 13)
        
        userDescription.text = "Hello, world!"
        userDescription.textColor = .ypWhite
        userDescription.font = UIFont.systemFont(ofSize: 13)
        
        if let symbol = UIImage(systemName: "ipad.and.arrow.forward") {
            exitButton = UIButton.systemButton(
                with: symbol,
                target: self,
                action: nil
            )
        }
        exitButton.tintColor = .ypRed
    }
    
    private func loadViews() {
        [profilePicture, userName, userNickname, userDescription, exitButton].forEach { uiview in
            uiview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(uiview)
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
    
    
    
    
}
