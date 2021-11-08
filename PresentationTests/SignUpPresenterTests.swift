//
//  SignUpPresenterTests.swift
//  PresentationTests
//
//  Created by Gustavo Soares on 06/11/21.
//

import XCTest
import Domain

@testable import Presentation

class SignUpPresenterTests: XCTestCase {
    
    func test_signUp_showErrorMessage_whenNameNotProvided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy)
        let expectation = expectation(description: "Waiting")
        
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(message: "Empty name"))
            expectation.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(name: nil))
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_signUp_showErrorMessage_whenEmailNotProvided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy)
        let expectation = expectation(description: "Waiting")
        
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(message: "Empty email"))
            expectation.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(email: nil))
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_signUp_showErrorMessage_whenPasswordNotProvided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy)
        let expectation = expectation(description: "Waiting")
        
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(message: "Empty password"))
            expectation.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(password: nil))
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_signUp_showErrorMessage_whenPasswordConfirmationNotProvided() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy)
        let expectation = expectation(description: "Waiting")
        
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(message: "Empty password confirmation"))
            expectation.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_signUp_showErrorMessage_whenPasswordConfirmationIsDiferentFromPassword() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy)
        let expectation = expectation(description: "Waiting")
        
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(message: "Password confirmation is wrong then password"))
            expectation.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: "secret"))
        wait(for: [expectation], timeout: 1.0)
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
        let expectation = expectation(description: "Waiting")
        
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(message: "Email is invalid"))
            expectation.fulfill()
        }
        
        emailValidatorSpy.simulateInvalidEmail()
        sut.signUp(viewModel: signUpViewModel)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_signUp_shouldCallAddAccount_withCorrectValues() {
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAcountSpy: addAccountSpy)
        sut.signUp(viewModel: makeSignUpViewModel())
        XCTAssertEqual(addAccountSpy.addAccountModel, makeAddAccountModel())
    }
    
    func test_signUp_shouldShowError_whenAddAccountFails() {
        let addAccountSpy = AddAccountSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy, addAcountSpy: addAccountSpy)
        let expectation = expectation(description: "Waiting")
        
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeRequiredAlertViewModel(message: "Error on addAccount"))
            expectation.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel())
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [expectation], timeout: 1)
    }
    
    func test_signUp_shouldShowLoading_beforeAndAfterCallAddAccount() {
        
        let loadingViewSpy = LoadingViewSpy()
        let addAccountSpy = AddAccountSpy()
        let sut = makeSut(addAcountSpy: addAccountSpy, loadingViewSpy: loadingViewSpy)
        let expectationForBeforeCall = expectation(description: "Waiting before")
        let expectationForAfterCall = expectation(description: "Waiting after")
        
        loadingViewSpy.observe { loadingViewModel in
            XCTAssertEqual(loadingViewModel, LoadingViewModel(isLoading: true))
            expectationForBeforeCall.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel())
        wait(for: [expectationForBeforeCall], timeout: 1.0)
        
        loadingViewSpy.observe { loadingViewModel in
            XCTAssertEqual(loadingViewModel, LoadingViewModel(isLoading: false))
            expectationForAfterCall.fulfill()
        }
        
        addAccountSpy.completeWithError(.unexpected)
        wait(for: [expectationForAfterCall], timeout: 1.0)
    }
    
    func test_signUp_shouldShowSuccessMessage_afterAddAccountSucceeds() {
        let addAccountSpy = AddAccountSpy()
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertViewSpy: alertViewSpy, addAcountSpy: addAccountSpy)
        let expectation = expectation(description: "Waiting")
        
        alertViewSpy.observe { [weak self] viewModel in
            XCTAssertEqual(viewModel, self?.makeSuccessAlertViewModel(message: "Account created :)"))
            expectation.fulfill()
        }
        
        sut.signUp(viewModel: makeSignUpViewModel())
        addAccountSpy.completeWithAccount(AccountModel(accessToken: "dummyaccesstoken"))
        wait(for: [expectation], timeout: 1)
    }
}


extension SignUpPresenterTests {
    
    func makeSut(alertViewSpy: AlertViewSpy = AlertViewSpy(),
                 emailValidatorSpy: EmailValidatorSpy = EmailValidatorSpy(),
                 addAcountSpy: AddAccountSpy = AddAccountSpy(),
                 loadingViewSpy: LoadingViewSpy = LoadingViewSpy(),
                 file: StaticString = #file, line: UInt = #line) -> SignUpPresenter {
       
        let sut = SignUpPresenter(alertView: alertViewSpy, emailValidator: emailValidatorSpy, addAccount: addAcountSpy, loadingView: loadingViewSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    func makeSignUpViewModel(name: String? = "Dummy", email: String? = "dummy@email.com", password: String? = "dummy", passwordConfirmation: String? = "dummy") -> SignUpViewModel {
        SignUpViewModel(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation)
    }
    
    func makeRequiredAlertViewModel(message: String) -> AlertViewModel {
        AlertViewModel(title: "Error on validation", message: message)
    }
    
    func makeSuccessAlertViewModel(message: String) -> AlertViewModel {
        AlertViewModel(title: "Success", message: message)
    }
    
    
    final class LoadingViewSpy: LoadingView {
        
        var emit: ((LoadingViewModel) -> Void)?
        
        func observe(completion: @escaping (LoadingViewModel) -> Void) {
            self.emit = completion
        }
        
        func display(viewModel: LoadingViewModel) {
            self.emit?(viewModel)
        }
    }
    
    final class AddAccountSpy: AddAccount {
        
        var addAccountModel: AddAccountModel?
        var completion: ((Result<AccountModel, DomainError>) -> Void)?
        
        func add(addAccountModel: AddAccountModel, completionHandler: @escaping (Result<AccountModel, DomainError>) -> Void) {
            self.addAccountModel = addAccountModel
            self.completion = completionHandler
        }
        
        func completeWithError(_ error: DomainError) {
            completion?(.failure(error))
        }
        
        func completeWithAccount(_ account: AccountModel)  {
            completion?(.success(account))
        }
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
        
        var emit: ((AlertViewModel) -> Void)?
        
        func showMessage(viewModel: AlertViewModel) {
            self.emit?(viewModel)
        }
        
        func observe(completion: @escaping (AlertViewModel) -> Void) {
            self.emit = completion
        }
    }
}
