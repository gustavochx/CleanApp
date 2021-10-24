//
//  TestFactories.swift
//  DataTests
//
//  Created by Gustavo Henrique Frota Soares on 24/10/21.
//

import Foundation

func makeUrl() -> URL {
    return URL(string: String("http://any-url.com"))!
}

func makeInvalidData() -> Data {
    return Data("".utf8)
}
