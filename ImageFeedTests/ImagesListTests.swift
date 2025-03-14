//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Артем Табенский on 14.03.2025.
//

import Foundation

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        viewController.viewDidLoad()
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testFetchPhotosNextPageCalled() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.fetchPhotosNextPage()
        
        // Then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
    
    func testChangeLikeCalled() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.changeLike(photoId: "testPhotoId", isLiked: true) { _ in }
        
        // Then
        XCTAssertTrue(presenter.changeLikeCalled)
    }
    
    func testGetFormattedDateCalled() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        _ = presenter.getFormattedDate(from: Date())
        
        // Then
        XCTAssertTrue(presenter.getFormattedDateCalled)
    }
    
    func testUpdateTableViewAnimatedCalled() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        viewController.updateTableViewAnimated()
        
        // Then
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
    }
    
    func testShowErrorCalled() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        viewController.showError(message: "Test Error")
        
        // Then
        XCTAssertTrue(viewController.showErrorCalled)
    }
}
