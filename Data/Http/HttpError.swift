//
//  HttpError.swift
//  Data
//
//  Created by Gustavo Henrique Frota Soares on 01/03/21.
//

import Foundation

public enum HttpError: Error {
    case noConnectivity
    case badRequest
    case serverError
    case unauthorized
    case forbidden
}
