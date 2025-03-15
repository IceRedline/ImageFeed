//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Артем Табенский on 14.03.2025.
//

import Foundation
import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var updateTableViewAnimatedCalled: Bool = false
    var showErrorCalled: Bool = false
    
    func viewDidLoad() {
        presenter?.viewDidLoad()
    }
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
    
    func showError(message: String) {
        showErrorCalled = true
    }
}
