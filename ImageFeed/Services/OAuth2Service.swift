//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Артем Табенский on 25.01.2025.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let tokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    private func makeOauthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            logError("[makeOauthTokenRequest]: AuthServiceError - failedToCreateRequest (baseURL is nil)")
            return nil
        }
        
        guard let url = URL(string: "/oauth/token"
                            + "?client_id=\(Constants.accessKey)"
                            + "&&client_secret=\(Constants.secretKey)"
                            + "&&redirect_uri=\(Constants.redirectURI)"
                            + "&&code=\(code)"
                            + "&&grant_type=authorization_code",
                            relativeTo: baseURL) else {
            logError("[makeOauthTokenRequest]: AuthServiceError - failedToCreateRequest (invalid URL)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpRequestMethods.post
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            logError("[fetchOAuthToken]: AuthServiceError - invalidRequest (duplicate code: \(code))")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOauthTokenRequest(code: code) else {
            logError("[fetchOAuthToken]: AuthServiceError - failedToCreateRequest (invalid request for code: \(code))")
            DispatchQueue.main.async {
                completion(.failure(NetworkError.urlSessionError))
            }
            return
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let responseBody):
                    self.tokenStorage.token = responseBody.accessToken
                    completion(.success(responseBody.accessToken))
                case .failure(let error):
                    self.logError("[fetchOAuthToken]: NetworkError - \(error.localizedDescription) (code: \(code))")
                    completion(.failure(error))
                }
                self.task = nil
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func logError(_ message: String) {
        print(message)
    }
}
