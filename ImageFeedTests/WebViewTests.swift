//
//  WebViewTests.swift
//  ImageFeedTests
//
//  Created by Артем Табенский on 13.03.2025.
//

@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view // обращение, чтобы вызвать viewDidLoad
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        //given
        let viewController = WebViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad() // обращение, чтобы вызвать viewDidLoad
        
        //then
        XCTAssertEqual(viewController.loadRequestCalled, true)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        //when
        let isHidden = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(isHidden)
    }
    
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        let url = authHelper.authURL()
        let urlString = url!.absoluteString
        
        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        //given
        let authHelper = AuthHelper(configuration: AuthConfiguration.standard)
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        
        urlComponents?.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents?.url
        
        let code = authHelper.code(from: url!)
        
        XCTAssertEqual(code, "test code")
    }
}
