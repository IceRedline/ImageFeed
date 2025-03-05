//
//  Photo.swift
//  ImageFeed
//
//  Created by Артем Табенский on 26.02.2025.
//

import Foundation

struct Photo {
    var photoResult: PhotoResult
    
    var id: String {
        return photoResult.id
    }
    
    var size: CGSize {
        return CGSize(width: photoResult.width, height: photoResult.height)
    }
    
    var createdAt: Date? {
        return photoResult.createdAt
    }
    
    var welcomeDescription: String? {
        return photoResult.description
    }
    
    var thumbImageURL: String {
        return photoResult.urls.small
    }
    
    var fullImagevarURL: String {
        return photoResult.urls.full
    }
    
    var isLiked: Bool {
        get { photoResult.likedByUser }
        set { photoResult.likedByUser = newValue } 
    }
    
    init(photoResult: PhotoResult) {
        self.photoResult = photoResult
    }
}
