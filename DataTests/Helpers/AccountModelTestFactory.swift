//
//  AccountModelTestFactory.swift
//  DataTests
//
//  Created by Gustavo Henrique Frota Soares on 24/10/21.
//

import Foundation
import Domain

func makeAccountModel() -> AccountModel {
    AccountModel(accessToken: "dummyaccesstoken")
}

func makeAddAccountModel() -> AddAccountModel {
    AddAccountModel(name: "Dummy", email: "dummy@email.com", password: "dummy", confirmationPassword: "dummy")
}
