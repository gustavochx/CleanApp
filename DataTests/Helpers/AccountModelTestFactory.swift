//
//  AccountModelTestFactory.swift
//  DataTests
//
//  Created by Gustavo Henrique Frota Soares on 24/10/21.
//

import Foundation
import Domain

func makeAccountModel() -> AccountModel {
    return AccountModel(id: "any_id", name: "any", email: "any_email@mail.com", password: "any_pass")
}
