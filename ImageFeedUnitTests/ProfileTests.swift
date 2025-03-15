//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Артем Табенский on 14.03.2025.
//

import Foundation
@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        viewController.configure(presenter)
        
        //when
        viewController.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled, "Метод viewDidLoad() не был вызван")
    }
    
    func testExitButtonTappedCallsLogout() {
        // given
        let presenter = ProfilePresenterSpy()
        let viewController = ProfileViewControllerSpy()
        viewController.configure(presenter)

        // когда
        viewController.exitButtonTapped()

        // then
        XCTAssertTrue(presenter.didCallLogout, "Метод logout() не был вызван")
    }
    
    func testProfileDetailsUpdated() {
        // given
        let presenter = ProfilePresenterSpy()
        let viewController = ProfileViewControllerSpy()
        viewController.configure(presenter)

        // когда
        viewController.viewDidLoad()

        // then
        XCTAssertTrue(viewController.profileDetailsUpdated, "Детали профиля не были обновлены")
    }
    
}
