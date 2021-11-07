//
//  SignUpPresenterTests.swift
//  PresentationTests
//
//  Created by Gustavo Soares on 06/11/21.
//

import XCTest

class SignUpPresenter {
    
    private let alertView: AlertView
    
    init(alertView: AlertView) {
        self.alertView = alertView
    }
    
    func signUp(viewModel: SignUpViewModel) {
        
        if viewModel.name == nil || viewModel.name!.isEmpty {
            alertView.showMessage(viewModel: AlertViewModel(title: "Error on validation", message: "Empty name"))
        } else if viewModel.email == nil || viewModel.email!.isEmpty {
            alertView.showMessage(viewModel: AlertViewModel(title: "Error on validation", message: "Empty email"))
        } else if viewModel.password == nil || viewModel.password!.isEmpty {
            alertView.showMessage(viewModel: AlertViewModel(title: "Error on validation", message: "Empty password"))
        }
    }
    
}

protocol AlertView {
    func showMessage(viewModel: AlertViewModel)
}

struct AlertViewModel: Equatable {
    var title: String
    var message: String
}


struct SignUpViewModel {
    var name: String?
    var email: String?
    var password: String?
    var passwordConfirmation: String?
}

class SignUpPresenterTests: XCTestCase {

    func test_signUp_showErrorMessage_forNameNotProvided() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: nil, email: "dummy@email", password: "dummy", passwordConfirmation: "dummy")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Error on validation", message: "Empty name"))
    }
    
    func test_signUp_showErrorMessage_forEmailNotProvided() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "Dummy", email: nil, password: "dummy", passwordConfirmation: "dummy")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Error on validation", message: "Empty email"))
    }
    
    func test_signUp_showErrorMessage_forPasswordNotProvided() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "Dummy", email: "dummy@email", password: nil, passwordConfirmation: "dummy")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Error on validation", message: "Empty password"))
    }
}


extension SignUpPresenterTests {
    
    func makeSut() -> (sut: SignUpPresenter, alertViewSpy: AlertViewSpy) {
        let alertViewSpy = AlertViewSpy()
        let sut = SignUpPresenter(alertView: alertViewSpy)
        return (sut: sut, alertViewSpy: alertViewSpy)
    }
    
    class AlertViewSpy: AlertView {
        
        var viewModel: AlertViewModel?
        
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
}
