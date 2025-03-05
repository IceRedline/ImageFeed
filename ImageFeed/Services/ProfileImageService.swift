//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Артем Табенский on 16.02.2025.
//

import Foundation

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    static let shared = ProfileImageService()
    private init() {}
    
    var avatarURL: String?
    private var currentTask: URLSessionDataTask?
    private let queue = DispatchQueue(label: "com.profileImageService.queue", attributes: .concurrent)
    
    // MARK: - Methods
    
    private func requestImageURL(username: String) -> URLRequest? {
        
        let baseURL = Constants.defaultBaseURL
        
        guard let url = URL(string: "users/" + username, relativeTo: baseURL) else {
            logError("[requestImageURL]: NetworkError - failed to create profile request (username: \(username))")
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
                logError("[fetchProfileImageURL]: NetworkError - failed to create request (username: \(username))")
                return
            }
            
            let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
                guard let self = self else { return }
                
                switch result {
                case .success(let imageResult):
                    self.avatarURL = imageResult.profileImage.medium
                    completion(.success(self.avatarURL!))
                    print("[fetchProfileImageURL]: Success - avatar URL: \(self.avatarURL!)")
                    
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL" : self.avatarURL!]
                    )
                case .failure(let error):
                    logError("[fetchProfileImageURL]: NetworkError - \(error.localizedDescription) (username: \(username))")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    private func logError(_ message: String) {
        print(message)
    }
}
