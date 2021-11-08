//
//  SignUpViewModel.swift
//  Presentation
//
//  Created by Gustavo Soares on 08/11/21.
//

import Foundation

public final struct SignUpViewModel {
    
    // MARK: Public variables
    public var name: String?
    public var email: String?
    public var password: String?
    public var passwordConfirmation: String?
    
    // MARK: Constructor
    public init(name: String? = nil, email: String? = nil, password: String? = nil, passwordConfirmation: String? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}
