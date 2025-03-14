//
//  ImageListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Артем Табенский on 14.03.2025.
//

import Foundation

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    
    func updateTableViewAnimated()
    func showError(message: String)
}
