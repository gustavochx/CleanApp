//
//  AddAccount.swift
//  Domain
//
//  Created by Gustavo Henrique Frota Soares on 23/02/21.
//

import Foundation

public protocol AddAccount {
    func add(addAccountModel: AddAccountModel, completionHandler: @escaping (Result<AccountModel, Error>) -> Void)
}

public struct AddAccountModel {
    public var name: String
    public var email: String
    public var password: String
    public var passwordConfirmation: String
}
