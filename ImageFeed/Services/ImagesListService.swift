//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Артем Табенский on 26.02.2025.
//

import Foundation

public final class ImagesListService {
    
    private var lastLoadedPage: Int?
    private var task: URLSessionTask? = nil
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    var photos: [Photo] = []
    
    // MARK: - Methods
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard task == nil else { return }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let url = URL(string: "/photos?page=\(nextPage)", relativeTo: Constants.defaultBaseURL) else {
            logError("[fetchPhotosNextPage]: NetworkError - failed to create URL")
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpRequestMethods.get
        request.setValue("Bearer \(OAuth2TokenStorage().token ?? "no token")", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let photoResults):
                let newPhotos = photoResults.map { Photo(photoResult: $0) }
                self.photos.append(contentsOf: newPhotos)
                self.lastLoadedPage = nextPage
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self
                )
                
                completion(.success(newPhotos))
                
            case .failure(let error):
                self.logError("[fetchPhotosNextPage]: NetworkError - \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let url = URL(string: "/photos/\(photoId)/like", relativeTo: Constants.defaultBaseURL) else {
            logError("[changeLike]: NetworkError - failed to create URL")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(OAuth2TokenStorage().token ?? "no token")", forHTTPHeaderField: "Authorization")
        request.httpMethod = isLiked ? httpRequestMethods.delete : httpRequestMethods.post
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<LikeResponse, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success:
                print("Лайк изменён!")
                
                DispatchQueue.main.async{
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        self.photos[index].isLiked.toggle()
                        print("Фото изменено!")
                        completion(.success(()))
                    }
                }
                
            case .failure(let error):
                self.logError("[changeLike]: NetworkError - \(error.localizedDescription)")
                completion(.failure(error))
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
