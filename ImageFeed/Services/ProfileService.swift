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
    
    private let baseURL = "https://api.unsplash.com"
    private let queue = DispatchQueue(label: "com.unsplashapi.profile", attributes: .concurrent)
    
    private(set) var profile: Profile?
    
    private func makeProfileTokenRequest(token: String) -> URLRequest? {
        guard let url = URL(string: baseURL + "/me") else {
            print("Ошибка: невозможно создать URL для запроса токена")
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
                    completion(.failure(error))
                }
            }
            task.resume()
            
            /*
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                    self.profile = Profile(profileResult: profileResult)
                    completion(.success(self.profile!))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
            */
        }
    }

}
