//
//  EmailValidator.swift
//  Presentation
//
//  Created by Gustavo Soares on 08/11/21.
//

import Foundation

public protocol EmailValidator {
    func isValid(email: String) -> Bool
}
