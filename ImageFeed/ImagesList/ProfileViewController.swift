//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Артем Табенский on 08.01.2025.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    private lazy var profilePicture: UIImageView = {
        let view = UIImageView()
        let image = UIImage.stub
        view.image = image
        view.accessibilityIdentifier = AccessibilityIDs.profilePicture
        return view
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.accessibilityIdentifier = AccessibilityIDs.userName
        return label
    }()
    
    private let userNickname: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.accessibilityIdentifier = AccessibilityIDs.userNickame
        return label
    }()
    
    private let userDescription: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13)
        label.accessibilityIdentifier = AccessibilityIDs.userDescription
        return label
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: nil,
            action: #selector(exitButtonTapped)
        )
        button.tintColor = .ypRed
        button.accessibilityIdentifier = AccessibilityIDs.exitButton
        return button
    }()
    
    private let profileService = ProfileService.shared
    
    var presenter: ProfilePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(ProfilePresenter())
        
        loadViews()
        loadConstraints()
        
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - Methods
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    private func loadViews() {
        view.backgroundColor = .ypBlack
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
    
    func updateProfileDetails(with profile: Profile) {
        userName.text = profile.name
        userNickname.text = profile.loginName
        userDescription.text = profile.bio
    }
    
    func updateAvatar(with url: URL?) {
        profilePicture.kf.setImage(with: url, placeholder: UIImage.stub)
        profilePicture.layoutIfNeeded()
        profilePicture.layer.cornerRadius = profilePicture.frame.width / 2
        profilePicture.clipsToBounds = true
    }
    
    @objc func exitButtonTapped() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Да", style: .default) { _ in
            self.presenter?.logout()
        }
        let actionNo = UIAlertAction(title: "Нет", style: .cancel)
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        present(alert, animated: true)
    }
}
