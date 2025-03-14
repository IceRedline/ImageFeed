//
//  ImageListPresenterProtocol.swift
//  ImageFeed
//
//  Created by Артем Табенский on 14.03.2025.
//

import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLiked: Bool, completion: @escaping (Bool) -> Void)
    func getPhotos() -> [Photo]
    func getPhoto(at indexPath: IndexPath) -> Photo
    func getFormattedDate(from date: Date?) -> String
}
