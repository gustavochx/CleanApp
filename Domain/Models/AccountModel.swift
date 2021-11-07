//
//  AddAccountModel.swift
//  Domain
//
//  Created by Gustavo Henrique Frota Soares on 23/02/21.
//

import Foundation

public struct AccountModel: Model {
    public var accessToken: String

    public init(accessToken: String) {
        self.accessToken = accessToken
    }
}
