//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Артем Табенский on 22.12.2024.
//

import XCTest

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        app.launchArguments = ["UITests"]
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssert(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("scpd2604@gmail.com")
        sleep(2)
        let start = webView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.3))
        let end = webView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        start.press(forDuration: 0.2, thenDragTo: end)
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        sleep(1)
        passwordTextField.typeText("bakkac-gobge8-cyjqUj")
        webView.swipeUp()
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let table = app.tables["ImageList"]
        XCTAssertTrue(table.waitForExistence(timeout: 5))
        table.swipeUp()
        
        let cell = table.children(matching: .cell).element(boundBy: 1)
        
        cell.buttons["LikeButton"].tap()
        sleep(1)
        cell.buttons["LikeButton"].tap()
        sleep(1)
        
        cell.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        app.buttons["BackButton"].tap()
        
        XCTAssertTrue(app.tables["ImageList"].waitForExistence(timeout: 5))
    }
    
    func testProfile() throws {
        let table = app.tables["ImageList"]
        XCTAssertTrue(table.waitForExistence(timeout: 5))
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        let nameLabel = app.staticTexts["UserName"].label
        let nicknameLabel = app.staticTexts["UserNickname"].label
        let descriptionLabel = app.staticTexts["UserDescription"].label
        
        XCTAssertEqual(nameLabel, "Artyom Tabenskiy")
        XCTAssertEqual(nicknameLabel, "@iceredline")
        XCTAssertEqual(descriptionLabel, "This description is under security 😦")
        
        app.buttons["ExitButton"].tap()
        app.alerts.firstMatch.scrollViews.otherElements.buttons["Да"].tap()
        sleep(2)
        
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
}
