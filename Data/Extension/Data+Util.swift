//
//  Data+Util.swift
//  Data
//
//  Created by Gustavo Henrique Frota Soares on 07/04/21.
//

import Foundation

public extension Data {
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
    
    func toJson() -> [String: Any]? {
        try? JSONSerialization.jsonObject(with: self, options: .allowFragments) as? [String: Any]
    }
}
