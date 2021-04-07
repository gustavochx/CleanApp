//
//  DataTests.swift
//  DataTests
//
//  Created by Gustavo Henrique Frota Soares on 23/02/21.
//

import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase {

    func test_add_should_call_httpClient_with_correct_url() {

        let url = URL(string: String("http://any-url.com"))!
        let (sutRemoteAddAccount,httpClientSpy) = makeSut(url: url)
        
        sutRemoteAddAccount.add(addAcountModel: makeAddAccountModel()) { _ in

        }

        XCTAssertEqual(httpClientSpy.urls, [url])
    }

    func test_add_should_call_httpClient_with_correct_data() {

        let (sutRemoteAddAccount,httpClientSpy) = makeSut()
        let stubAddAccountModel = makeAddAccountModel()
        sutRemoteAddAccount.add(addAcountModel: stubAddAccountModel) { _ in

        }
        XCTAssertEqual(httpClientSpy.data, stubAddAccountModel.toData())
    }

    func test_add_should_complete_with_error_if_client_completes_with_error() {

        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        sut.add(addAcountModel: makeAddAccountModel()) { result in
            switch result {
                case .failure(let error):
                    XCTAssertEqual(error, .unexpected)
                case .success: XCTFail("Expected error receive \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivity)
        wait(for: [exp], timeout: 1)
    }

    func test_add_should_complete_with_error_if_client_completes_with_data() {

        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        sut.add(addAcountModel: makeAddAccountModel()) { result in

            switch result {
                case .failure(let error):
                    XCTAssertEqual(error, .unexpected)
                case .success: XCTFail("Expected error receive \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivity)
        wait(for: [exp], timeout: 1)
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

        var urls = [URL]()
        var data: Data?
        var completion: ((Result<Data, HttpError>) -> Void)?

        func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
            self.urls.append(url)
            self.data = data
            self.completion = completion
        }

        func completeWithError(_ error: HttpError) {
            completion?(.failure(error))
        }
    }
}
