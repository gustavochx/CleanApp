//
//  UseCasesIntegrationTests.swift
//  UseCasesIntegrationTests
//
//  Created by Gustavo Soares on 06/11/21.
//

import XCTest
import Data
import Infra
import Domain

class AddAcountIntegrationTests: XCTestCase {

    func test_addAccount() {
        
        let alamofireAdapter = AlamofireAdapter()
        let url = URL(string: "https://fordevs.herokuapp.com/api/signup")!
        let sut = RemoteAddAccount(url: url, httpClient: alamofireAdapter)
        let account = AddAccountModel(name: "Gustavo",
                                      email: "\(UUID().uuidString)@gmail.com",
                                      password: "secret",
                                      confirmationPassword: "secret")
        
        let expectation = expectation(description: "Waiting integration")
        
        sut.add(addAcountModel: account) { result in
            switch result {
            case .failure:
                XCTFail("Expect success got \(result) instead")
            case.success(let accountCreated):
                XCTAssertNotNil(accountCreated.accessToken)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }

}
