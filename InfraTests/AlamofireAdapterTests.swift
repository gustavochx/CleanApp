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
    
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data?, HttpError>) -> Void) {
        session.request(url, method: .post, parameters: data?.toJson(), encoding: JSONEncoding.default).responseData { dataResponse in
            switch dataResponse.result {
            case .failure: completion(.failure(.noConnectivity))
            default: break
            }
        }
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
    
    func test_post_should_complete_with_error_when_request_completes_with_error() {
        
        let sut = makeSut()
        UrlProtocolStub.simulate(data: nil, httpResponse: nil, error: makeError())
        let expectation = expectation(description: "Waiting")

        sut.post(to: makeUrl(), with: makeValidData()) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .noConnectivity)
            case .success: XCTFail("Expected error got \(result) instead")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
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
        let expectation = expectation(description: "waiting url to be called")

        sut.post(to: url, with: data) { _ in expectation.fulfill() }
        UrlProtocolStub.observeRequest { request in
            action(request)
        }
        wait(for: [expectation], timeout: timeoutExpected)
    }
    
}

class UrlProtocolStub: URLProtocol {
    
    static var emit: ((URLRequest) -> Void)?
    static var data: Data?
    static var error: Error?
    static var response: HTTPURLResponse?
    
    
    static func simulate(data: Data?, httpResponse: HTTPURLResponse?, error: Error?) {
        UrlProtocolStub.data = data
        UrlProtocolStub.response = httpResponse
        UrlProtocolStub.error = error
    }
    
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
        
        if let data = UrlProtocolStub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = UrlProtocolStub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = UrlProtocolStub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
