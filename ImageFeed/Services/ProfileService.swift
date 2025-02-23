//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Артем Табенский on 02.02.2025.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    
    private init() { }
    
    private let queue = DispatchQueue(label: "com.unsplashapi.profile", attributes: .concurrent)
    
    private(set) var profile: Profile?
    
    private func makeProfileTokenRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "/me", relativeTo: Constants.defaultBaseURL) else {
            logError("[makeProfileTokenRequest]: NetworkError - failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self, let request = makeProfileTokenRequest(token: token) else {
                self?.logError("[fetchProfile]: NetworkError - failed to create request (token: \(token))")
                completion(.failure(NetworkError.urlRequestError(URLError(.badServerResponse))))
                return
            }
            
            let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
                guard let self = self else { return }
                
                switch result {
                case .success(let profileResult):
                    self.profile = Profile(profileResult: profileResult)
                    completion(.success(self.profile!))
                case .failure(let error):
                    logError("[fetchProfile]: NetworkError - \(error.localizedDescription) (token: \(token))")
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
