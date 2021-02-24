//
//  DataTests.swift
//  DataTests
//
//  Created by Gustavo Henrique Frota Soares on 23/02/21.
//

import XCTest
import Domain

class RemoteAddAccount {

    private let url: URL
    private let httpClient: HttpPostClient

    init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }

    func add(addAcountModel: AddAccountModel) {
        httpClient.post(url: url)
    }
}

protocol HttpPostClient {
    func post(url: URL)
}

protocol HttpClientGet {
    func get(url: URL)
}

class RemoteAddAccountTests: XCTestCase {
    func test_add_should_call_httpClient_with_correct_url() {
        let url = URL(string: String("http://any-url.com"))!
        let httpClientSpy = HttpClientSpy()
        let sutRemoteAddAccount = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        sutRemoteAddAccount.add()
        XCTAssertEqual(httpClientSpy.url, url)
    }

    func test_add_should_call_httpClient_with_correct_data() {
        let httpClientSpy = HttpClientSpy()
        let sutRemoteAddAccount = RemoteAddAccount(url: URL(string: String("http://any-url.com"))!, httpClient: httpClientSpy)
        sutRemoteAddAccount.add()
        XCTAssertEqual(httpClientSpy.data, data)
    }


}

extension RemoteAddAccountTests {

    class HttpClientSpy: HttpPostClient {
        var url: URL?

        func post(url: URL) {
            self.url = url
        }
    }
}
