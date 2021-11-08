//
//  SignUpPresenterTests.swift
//  PresentationTests
//
//  Created by Gustavo Soares on 06/11/21.
//

import XCTest

@testable import Presentation

class SignUpPresenterTests: XCTestCase {

    func test_signUp_showErrorMessage_whenNameNotProvided() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: nil, email: "dummy@email", password: "dummy", passwordConfirmation: "dummy")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Error on validation", message: "Empty name"))
    }
    
    func test_signUp_showErrorMessage_whenEmailNotProvided() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "Dummy", email: nil, password: "dummy", passwordConfirmation: "dummy")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Error on validation", message: "Empty email"))
    }
    
    func test_signUp_showErrorMessage_whenPasswordNotProvided() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "Dummy", email: "dummy@email", password: nil, passwordConfirmation: "dummy")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Error on validation", message: "Empty password"))
    }
    
    func test_signUp_showErrorMessage_whenPasswordConfirmationNotProvided() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "Dummy", email: "dummy@email", password: "dummy", passwordConfirmation: nil)
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Error on validation", message: "Empty password confirmation"))
    }
    
    func test_signUp_showErrorMessage_whenPasswordConfirmationIsDiferentFromPassword() {
        let (sut, alertViewSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "Dummy", email: "dummy@email", password: "dummy", passwordConfirmation: "secret")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Error on validation", message: "Password confirmation is wrong then password"))
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
