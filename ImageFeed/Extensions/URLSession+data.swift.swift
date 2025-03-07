//
//  URLSession+data.swift.swift
//  ImageFeed
//
//  Created by Артем Табенский on 27.01.2025.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidResponse
    case noData
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
}


extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let task = data(for: request) { (result: Result<Data, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let decodedObject = try decoder.decode(T.self, from: data)
                        completion(.success(decodedObject))
                    } catch {
                        self.logError("[objectTask]: DecodingError - \(error.localizedDescription), Data: \(String(data: data, encoding: .utf8) ?? "nil")")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    self.logError("[objectTask]: NetworkError - \(error.localizedDescription) (URL: \(request.url?.absoluteString ?? "nil"))")
                    completion(.failure(error))
                }
            }
        }
        return task
    }

    private func logError(_ message: String) {
        print(message)
    }
}
