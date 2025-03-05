//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Артем Табенский on 03.03.2025.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
