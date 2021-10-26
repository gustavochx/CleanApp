//
//  InfraTests.swift
//  InfraTests
//
//  Created by Gustavo Henrique Frota Soares on 24/10/21.
//

import XCTest
import Alamofire
import Data

class AlamofireAdapter {
    
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func post(to url: URL, with data: Data?) {
        session.request(url, method: .post, parameters: data?.toJson(), encoding: JSONEncoding.default).resume()
    }
}

class AlamofireAdapterTests: XCTestCase {
    
    func test_post_should_make_request_with_valid_url_and_method() {
        
        let testingUrl = makeUrl()
        
        testRequest(data: makeValidData(), timeoutExpected: 1.0) { request in
            XCTAssertEqual(testingUrl, request.url)
            XCTAssertEqual(HTTPMethod.post.rawValue, request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)    
        }        
    }
    
    func test_post_should_make_request_with_empty_body() {
        testRequest(data: makeInvalidData(), timeoutExpected: 1.0) { request in
            XCTAssertNil(request.httpBodyStream)
        }
    }
    
}

extension AlamofireAdapterTests {
    
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> AlamofireAdapter {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.protocolClasses = [UrlProtocolStub.self]
        let sut = AlamofireAdapter(session: Session(configuration: sessionConfiguration))
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    func testRequest(url: URL = makeUrl(),
                     data: Data?,
                     timeoutExpected: TimeInterval,
                     action: @escaping ((URLRequest) -> Void)) {
        
        
        let sut = makeSut()
        sut.post(to: url, with: data)
        let expectation = expectation(description: "waiting url to be called")
        
        UrlProtocolStub.observeRequest { request in
            action(request)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeoutExpected)
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
    
    override func stopLoading() {}
}
