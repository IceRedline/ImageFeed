//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Артем Табенский on 14.03.2025.
//

import Foundation

final class ImagesListPresenter: ImagesListPresenterProtocol {
    private let imagesListService = ImagesListService()
    private var photos: [Photo] = []
    private var imagesListServiceObserver: NSObjectProtocol?
    
    weak var view: ImagesListViewControllerProtocol?
    
    func viewDidLoad() {
        print("ImagesList presenter загружен!")
        addObserverToFetchNewPage()
        fetchPhotosNextPage()
    }
    
    private func addObserverToFetchNewPage() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.view?.updateTableViewAnimated()
            }
    }
    
    public func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage { [weak self] (result: Result<[Photo], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let newPhotos):
                self.photos.append(contentsOf: newPhotos)
                self.view?.updateTableViewAnimated()
            case .failure(let error):
                self.view?.showError(message: error.localizedDescription)
            }
        }
    }
    
    func changeLike(photoId: String, isLiked: Bool, completion: @escaping (Bool) -> Void) {
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photoId, isLiked: isLiked) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success:
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    self.photos[index].isLiked.toggle()
                }
                completion(true)
            case .failure:
                self.view?.showError(message: "Не удалось изменить лайк")
                completion(false)
            }
        }
    }
    
    func getPhotos() -> [Photo] {
        return photos
    }
    
    func getPhoto(at indexPath: IndexPath) -> Photo {
        return photos[indexPath.row]
    }
    
    func getFormattedDate(from date: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return date.map { formatter.string(from: $0) } ?? ""
    }
}
