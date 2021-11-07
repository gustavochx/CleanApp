//
//  UrlProtocolStub.swift
//  InfraTests
//
//  Created by Gustavo Henrique on 27/10/21.
//

import Foundation

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
