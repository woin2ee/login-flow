//
//  SignUpViewModel.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/08/02.
//

import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelType {
    
    struct Input {
        var id: Driver<String>
        var email: Driver<String>
        var password: Driver<String>
        var rePassword: Driver<String>
        var signUpRequest: Signal<Void>
    }
    
    struct Output {
        var signUp: Signal<Void>
        var idValidation: Driver<Bool>
        var emailValidation: Driver<Bool>
        var passwordValidation: Driver<Bool>
        var signUpButtonEnable: Driver<Bool>
        var error: Signal<Error>
    }
    
    private var userSignUpUseCase: UserSignUpUseCaseProtocol
    
    init(userSignUpUseCase: UserSignUpUseCaseProtocol) {
        self.userSignUpUseCase = userSignUpUseCase
    }
    
    func transform(input: Input) -> Output {
        let errorTracker: ErrorTracker = .init()
        let signUpInfo = Driver.combineLatest(
            input.id,
            input.email,
            input.password
        )
        let idValidation = input.id
            .map { self.validateId($0) }
        let emailValidation = input.email
            .map { self.validateEmail($0) }
        let passwordValidation = Driver.combineLatest(input.password, input.rePassword)
            .map { self.validatePassword($0, $1) }
        let signUpButtonEnable = Driver.combineLatest(
            idValidation,
            emailValidation,
            passwordValidation
        )
            .map { $0 && $1 && $2 }
        let signUp = input.signUpRequest
            .withLatestFrom(signUpInfo)
            .flatMapFirst { id, email, password in
                self.userSignUpUseCase.execute(
                    query: .init(
                        id: id,
                        password: password,
                        memberInfo: .init(
                            email: email,
                            passport: ""
                        )
                    )
                )
                .trackError(errorTracker)
                .asSignal(onErrorSignalWith: .empty())
            }
        
        return Output.init(
            signUp: signUp,
            idValidation: idValidation,
            emailValidation: emailValidation,
            passwordValidation: passwordValidation,
            signUpButtonEnable: signUpButtonEnable,
            error: errorTracker.asSignal()
        )
    }
    
    // MARK: - Private
    
    private func validateId(_ id: String) -> Bool {
        let idRegex = "[a-z0-9]{7,15}"
        return NSPredicate(format: "SELF MATCHES %@", idRegex).evaluate(with: id)
    }
    
    private func validatePassword(_ password: String, _ rePassword: String) -> Bool {
        guard password == rePassword else { return false }
        
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{5,15}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
