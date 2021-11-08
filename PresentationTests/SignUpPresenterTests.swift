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
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy)
        sut.signUp(viewModel: makeSignUpViewModel(name: nil))
        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(message: "Empty name"))
    }
    
    func test_signUp_showErrorMessage_whenEmailNotProvided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy)
        sut.signUp(viewModel: makeSignUpViewModel(email: nil))
        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(message: "Empty email"))
    }
    
    func test_signUp_showErrorMessage_whenPasswordNotProvided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy)
        sut.signUp(viewModel: makeSignUpViewModel(password: nil))
        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(message: "Empty password"))
    }
    
    func test_signUp_showErrorMessage_whenPasswordConfirmationNotProvided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy)
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))
        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(message: "Empty password confirmation"))
    }
    
    func test_signUp_showErrorMessage_whenPasswordConfirmationIsDiferentFromPassword() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy)
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: "secret"))
        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(message: "Password confirmation is wrong then password"))
    }
    
    func test_signUp_validatingEmail_forCorrectEmail() {
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(emailValidatorSpy: emailValidatorSpy)
        let signUpViewModel = makeSignUpViewModel()
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(emailValidatorSpy.email, signUpViewModel.email)
    }
    
    
    func test_signUp_showErrorMessage_whenInvalidEmailProvided() {
        let alertViewSpy = AlertViewSpy()
        let emailValidatorSpy = EmailValidatorSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy, emailValidatorSpy: emailValidatorSpy)
        let signUpViewModel = makeSignUpViewModel()
        emailValidatorSpy.simulateInvalidEmail()
        sut.signUp(viewModel: signUpViewModel)
        XCTAssertEqual(alertViewSpy.viewModel, makeRequiredAlertViewModel(message: "Email is invalid"))
    }
}


extension SignUpPresenterTests {
    
    func makeSut(alertViewSpy: AlertViewSpy = AlertViewSpy(), emailValidatorSpy: EmailValidatorSpy = EmailValidatorSpy()) -> SignUpPresenter {
        SignUpPresenter(alertView: alertViewSpy, emailValidator: emailValidatorSpy)
    }
    
    func makeSignUpViewModel(name: String? = "Dummy", email: String? = "dummy@email.com", password: String? = "dummy", passwordConfirmation: String? = "dummy") -> SignUpViewModel {
        SignUpViewModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
    
    func makeRequiredAlertViewModel(message: String) -> AlertViewModel {
        AlertViewModel(title: "Error on validation", message: message)
    }
    
    final class EmailValidatorSpy: EmailValidator {
        
        var isValid: Bool = true
        var email: String?
        
        func isValid(email: String) -> Bool {
            self.email = email
            return isValid
        }
        
        func simulateInvalidEmail() {
            isValid = false
        }
    }
    
    final class AlertViewSpy: AlertView {
        
        var viewModel: AlertViewModel?
        
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
}
