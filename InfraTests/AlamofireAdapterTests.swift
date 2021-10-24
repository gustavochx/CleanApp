//
//  InfraTests.swift
//  InfraTests
//
//  Created by Gustavo Henrique Frota Soares on 24/10/21.
//

import XCTest
import Alamofire

class AlamofireAdapter {
    
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func post(to url: URL) {
        session.request(url).resume()
    }
}

class AlamofireAdapterTests: XCTestCase {

    func test_() {

        let testingUrl = makeUrl()
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.protocolClasses = [UrlProtocolStub.self]

        let sut = AlamofireAdapter(session: Session(configuration: sessionConfiguration))
        sut.post(to: testingUrl)
        
        let expectation = expectation(description: "waiting url to be called")
        
        UrlProtocolStub.observeRequest { request in
            XCTAssertEqual(testingUrl, request.url)
            XCTAssertEqual(HTTPMethod.get.rawValue, request.httpMethod)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

class UrlProtocolStub: URLProtocol {
    
    static var emit: ((URLRequest) -> Void)?
    
    static func observeRequest(completion: @escaping (URLRequest) -> Void) {
        UrlProtocolStub.emit = completion
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        UrlProtocolStub.emit?(request)
    }
    
    override func stopLoading() {
        
    }
}
