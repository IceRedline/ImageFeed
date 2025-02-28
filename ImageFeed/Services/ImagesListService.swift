//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Артем Табенский on 26.02.2025.
//

import Foundation

final class ImagesListService {
    private(set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    private var task: URLSessionTask? = nil
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        guard task == nil else { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let url = URL(string: "/photos?page=\(nextPage)", relativeTo: Constants.defaultBaseURL) else {
            logError("[fetchPhotosNextPage]: NetworkError - failed to create URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(OAuth2TokenStorage().token ?? "no token")", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
                switch result {
                case .success(let photoResults):
                    // Преобразуем PhotoResult в Photo
                    let newPhotos = photoResults.map { photoResult in
                        Photo(photoResult: photoResult)
                    }
                    
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage = nextPage
                    
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self
                    )

                    print("Notification posted")
                    
                case .failure(let error):
                    self.logError("[fetchPhotosNextPage]: NetworkError - \(error.localizedDescription)")
                }
                self.task = nil
            
        }
        self.task = task
        task.resume()
    }
    
    private func logError(_ message: String) {
        print(message)
    }
}
