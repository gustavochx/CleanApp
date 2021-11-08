//
//  SignUpPresenter.swift
//  Presentation
//
//  Created by Gustavo Soares on 08/11/21.
//

import Foundation
import Domain

public struct SignUpViewModel {
    
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

public final class SignUpPresenter {
    
    // MARK: Private variables
    private let alertView: AlertView
    private let emailValidator: EmailValidator
    private let addAcount: AddAccount
    private let loadingView: LoadingView
    
    // MARK: Lifecycle
    init(alertView: AlertView, emailValidator: EmailValidator, addAccount: AddAccount, loadingView: LoadingView) {
        
        self.alertView = alertView
        self.emailValidator = emailValidator
        self.addAcount = addAccount
        self.loadingView = loadingView
    }
    
    // MARK: Methods
    func signUp(viewModel: SignUpViewModel) {
        
        if let message = validate(viewModel: viewModel) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Error on validation", message: message))
        } else {
            let addAccount = AddAccountModel(name: viewModel.name!, email: viewModel.email!, password: viewModel.password!, confirmationPassword: viewModel.passwordConfirmation!)
            loadingView.display(viewModel: LoadingViewModel(isLoading: true))
            addAcount.add(addAccountModel: addAccount) { [weak self] result in
                
                switch result {
                case .failure:
                    self?.alertView.showMessage(viewModel: AlertViewModel(title: "Error on validation", message: "Error on addAccount"))
                case .success:
                    break
                }
            }
        }
    }
    
    private func validate(viewModel: SignUpViewModel) -> String? {
        
        if viewModel.name == nil || viewModel.name!.isEmpty {
            return "Empty name"
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            return "Empty email"
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            return "Empty password"
        } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
            return "Empty password confirmation"
        } else if viewModel.password != viewModel.passwordConfirmation {
            return "Password confirmation is wrong then password"
        } else if !emailValidator.isValid(email: viewModel.email!) {
            return "Email is invalid"
        }
        return nil
    }
    
}
