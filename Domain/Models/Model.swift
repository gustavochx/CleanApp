//
//  Model.swift
//  Domain
//
//  Created by Gustavo Henrique Frota Soares on 24/02/21.
//

import Foundation


public protocol Model: Codable, Equatable {}

public extension Model {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
