//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Артем Табенский on 16.02.2025.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String
}

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    static let shared = ProfileImageService()
    private init() {}
    
    private(set) var avatarURL: String?
    private var currentTask: URLSessionDataTask?
    private let queue = DispatchQueue(label: "com.profileImageService.queue", attributes: .concurrent)
    
    // MARK: - Methods
    
    private func requestImageURL(username: String) -> URLRequest? {
        
        guard let baseURL = URL(string: "https://api.unsplash.com/") else {
            print("Невозомжно создать baseURL")
            return nil
        }
        guard let url = URL(string: "users/" + username, relativeTo: baseURL) else {
            print("Не удалось создать запрос профиля")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(OAuth2TokenStorage().token ?? "no token")", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self, self.currentTask == nil else { return }
            
            guard let request = requestImageURL(username: username) else {
                print("Не получен запрос для изображения")
                return
            }
            
            let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
                guard let self = self else { return }
                
                switch result {
                case .success(let imageResult):
                    self.avatarURL = imageResult.profileImage.small
                    completion(.success(self.avatarURL!))
                    print("Parsed avatar URL: \(String(describing: avatarURL))")
                    
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL" : self.avatarURL!]
                    )
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
}
