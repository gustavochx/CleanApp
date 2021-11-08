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
        let (sut, alertViewSpy, _) = makeSut()
        let signUpViewModel = SignUpViewModel(name: nil, email: "dummy@email", password: "dummy", passwordConfirmation: "dummy")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Error on validation", message: "Empty name"))
    }
    
    func test_signUp_showErrorMessage_whenEmailNotProvided() {
        let (sut, alertViewSpy, _) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "Dummy", email: nil, password: "dummy", passwordConfirmation: "dummy")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Error on validation", message: "Empty email"))
    }
    
    func test_signUp_showErrorMessage_whenPasswordNotProvided() {
        let (sut, alertViewSpy, _) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "Dummy", email: "dummy@email", password: nil, passwordConfirmation: "dummy")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Error on validation", message: "Empty password"))
    }
    
    func test_signUp_showErrorMessage_whenPasswordConfirmationNotProvided() {
        let (sut, alertViewSpy, _) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "Dummy", email: "dummy@email", password: "dummy", passwordConfirmation: nil)
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Error on validation", message: "Empty password confirmation"))
    }
    
    func test_signUp_showErrorMessage_whenPasswordConfirmationIsDiferentFromPassword() {
        let (sut, alertViewSpy, _) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "Dummy", email: "dummy@email", password: "dummy", passwordConfirmation: "secret")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Error on validation", message: "Password confirmation is wrong then password"))
    }
    
    func test_signUp_validatingEmail_forCorrectEmail() {
        let (sut, _, emailValidatorSpy) = makeSut()
        let signUpViewModel = SignUpViewModel(name: "Dummy", email: "dummy@email.com", password: "dummy", passwordConfirmation: "dummy")
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }
}


extension SignUpPresenterTests {
    
    func makeSut() -> (sut: SignUpPresenter, alertViewSpy: AlertViewSpy, emailValidatorSpy: EmailValidatorSpy) {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = SignUpPresenter(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
        return (sut: sut, alertViewSpy: alertViewSpy, emailValidatorSpy: emailValidatorSpy)
    }
    
    final class EmailValidatorSpy: EmailValidator {
        
        private var isValid: Bool = true
        var email: String?
        
        func isValid(email: String) -> Bool {
            self.email = email
            return isValid
        }
    }
    
    final class AlertViewSpy: AlertView {
        
        var viewModel: AlertViewModel?
        
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
}
