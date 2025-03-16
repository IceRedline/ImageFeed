//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Артем Табенский on 14.03.2025.
//

import Foundation
import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var fetchPhotosNextPageCalled: Bool = false
    var changeLikeCalled: Bool = false
    var getFormattedDateCalled: Bool = false
    var photos: [ImageFeed.Photo] = []
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func changeLike(photoId: String, isLiked: Bool, completion: @escaping (Bool) -> Void) {
        changeLikeCalled = true
        completion(true)
    }
    
    func getPhotosCount() -> Int {
        return photos.count
    }
    
    func getPhoto(at indexPath: IndexPath) -> ImageFeed.Photo {
        guard indexPath.row < photos.count else {
            fatalError("Index out of range in getPhoto(at:)")
        }
        return photos[indexPath.row]
    }
    
    func getFormattedDate(from date: Date?) -> String {
        getFormattedDateCalled = true
        return "Formatted Date"
    }
}
