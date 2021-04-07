//
//  RemoteAddAccount.swift
//  Data
//
//  Created by Gustavo Henrique Frota Soares on 24/02/21.
//

import Foundation
import Domain

public final class RemoteAddAccount {

    private let url: URL
    private let httpClient: HttpPostClient

    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }

    public func add(addAcountModel: AddAccountModel, completion: @escaping (DomainError) -> Void) {
        httpClient.post(to: url, with: addAcountModel.toData()) { error in
            completion(.unexpected)
        }

    }
}

