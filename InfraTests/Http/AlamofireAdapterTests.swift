//
//  InfraTests.swift
//  InfraTests
//
//  Created by Gustavo Henrique Frota Soares on 24/10/21.
//

import XCTest
import Alamofire
import Infra

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
        expect(expectedResult: .failure(.noConnectivity), when: (data: nil, response: nil, error: makeError()))
    }

    func test_post_should_complete_with_error_on_all_invalid_cases() {
        expect(expectedResult: .failure(.noConnectivity), when: (data: makeValidData(), response: makeHttpResponse(), error: makeError()))
        expect(expectedResult: .failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: makeError()))
        expect(expectedResult: .failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: nil))
        expect(expectedResult: .failure(.noConnectivity), when: (data: nil, response: makeHttpResponse(), error: makeError()))
        expect(expectedResult: .failure(.noConnectivity), when: (data: nil, response: makeHttpResponse(), error: nil))
        expect(expectedResult: .failure(.noConnectivity), when: (data: nil, response: nil, error: nil))
    }

    func test_post_should_complete_with_error_when_request_completes_without_success() {
        expect(expectedResult: .failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 400), error: nil))
        expect(expectedResult: .failure(.unauthorized), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 401), error: nil))
        expect(expectedResult: .failure(.forbidden), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 403), error: nil))
        expect(expectedResult: .failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 500), error: nil))
        expect(expectedResult: .failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 550), error: nil))
    }

    func test_post_should_complete_with_data_when_request_completes_with_success() {
        expect(expectedResult: .success(makeValidData()), when: (data: makeValidData(), response: makeHttpResponse(), error: nil))
    }

    func test_post_should_complete_with_data_when_request_completes_with_created() {
        expect(expectedResult: .success(nil), when: (data: nil, response: makeHttpResponse(statusCode: 204), error: nil))
        expect(expectedResult: .success(nil), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 204), error: nil))
        expect(expectedResult: .success(nil), when: (data: makeEmptyData(), response: makeHttpResponse(statusCode: 204), error: nil))
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
        var request: URLRequest?
        UrlProtocolStub.observeRequest { request = $0 }
        wait(for: [expectation], timeout: timeoutExpected)
        action(request!)
    }

    func expect(expectedResult: Result<Data?, HttpError>, when stub: (data: Data?, response: HTTPURLResponse?, error: Error?), file: StaticString = #filePath, line: UInt = #line) {

        let sut = makeSut()
        UrlProtocolStub.simulate(data: stub.data, httpResponse: stub.response, error: stub.error)
        let expectation = expectation(description: "Waiting")

        sut.post(to: makeUrl(), with: makeValidData()) { receivedResult in
            switch (expectedResult, receivedResult)  {
            case (.failure(let expectedError), .failure(let receivedError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedData), .success(let receivedData)): XCTAssertEqual(expectedData, receivedData, file: file, line: line)
            default: XCTFail("Expected error got \(expectedResult) instead", file: file, line: line)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

