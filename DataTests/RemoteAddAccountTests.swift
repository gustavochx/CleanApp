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

        let data = try? JSONEncoder().encode(addAcountModel)
        httpClient.post(to: url, with: data)
    }
}

protocol HttpPostClient {
    func post(to url: URL,with data: Data?)
}

protocol HttpClientGet {
    func get(url: URL)
}

class RemoteAddAccountTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() {

        let url = URL(string: String("http://any-url.com"))!

        let (sutRemoteAddAccount,httpClientSpy) = makeSut(url: url)

        sutRemoteAddAccount.add(addAcountModel: makeAddAccountModel())
        XCTAssertEqual(httpClientSpy.url, url)
    }

    func test_add_should_call_httpClient_with_correct_data() {

        let (sutRemoteAddAccount,httpClientSpy) = makeSut()

        let stubAddAccountModel = makeAddAccountModel()

        sutRemoteAddAccount.add(addAcountModel: stubAddAccountModel)

        let data = try? JSONEncoder().encode(stubAddAccountModel)

        XCTAssertEqual(httpClientSpy.data, data)
    }


}

extension RemoteAddAccountTests {

    func makeSut(url: URL = URL(string: String("http://any-url.com"))!) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sutRemoteAddAccount = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        return (sutRemoteAddAccount, httpClientSpy)
    }

    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any", email: "any_email@mail.com", password: "any_pass", confirmationPassword: "any_pass")
    }

    class HttpClientSpy: HttpPostClient {
        var url: URL?
        var data: Data?

        func post(to url: URL,with data: Data?) {
            self.url = url
            self.data = data
        }
    }
}
