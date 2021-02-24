//
//  AddAccount.swift
//  Domain
//
//  Created by Gustavo Henrique Frota Soares on 23/02/21.
//

import Foundation

protocol AddAccount {
    func add(addAccountModel: AddAccountModel, completionHandler: @escaping (Result<AccountModel, Error>) -> Void)
}

struct AddAccountModel {
    var name: String
    var email: String
    var password: String
    var passwordConfirmation: String
}
