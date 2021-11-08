//
//  AlertView.swift
//  Presentation
//
//  Created by Gustavo Soares on 08/11/21.
//

import Foundation

public protocol AlertView {
    func showMessage(viewModel: AlertViewModel)
}

public struct AlertViewModel: Equatable {

    // MARK: Public variables
    public var title: String
    public var message: String

    // MARK: Constructor
    
    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}


