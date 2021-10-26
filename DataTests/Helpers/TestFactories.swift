//
//  TestFactories.swift
//  DataTests
//
//  Created by Gustavo Henrique Frota Soares on 24/10/21.
//

import Foundation

func makeUrl() -> URL {
    URL(string: String("http://any-url.com"))!
}

func makeValidData() -> Data {
    Data("{\"name\":\"Gustavo\"}".utf8)
}

func makeInvalidData() -> Data {
    Data("".utf8)
}

func makeError() -> Error {
    NSError.init(domain: "any-error", code: 0)
}
