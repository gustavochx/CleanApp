//
//  HttpPostClient.swift
//  Data
//
//  Created by Gustavo Henrique Frota Soares on 24/02/21.
//

import Foundation

public protocol HttpPostClient {
    func post(to url: URL, with data: Data?)
}
