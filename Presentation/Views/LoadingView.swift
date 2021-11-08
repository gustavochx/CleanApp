//
//  LoadingView.swift
//  Presentation
//
//  Created by Gustavo Soares on 08/11/21.
//

import Foundation

protocol LoadingView {
    func display(viewModel: LoadingViewModel)
}

public struct LoadingViewModel: Equatable {
    
    public var isLoading: Bool
    
    public init(isLoading: Bool) {
        self.isLoading = isLoading
    }
}
