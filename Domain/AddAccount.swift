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

public struct AddAccountModel: Model {
    public var name: String
    public var email: String
    public var password: String
    public var passwordConfirmation: String

    public init(name: String, email: String, password: String, confirmationPassword: String ) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = confirmationPassword
    }
}

