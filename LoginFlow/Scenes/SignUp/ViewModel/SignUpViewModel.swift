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
        var signUp: Signal<Bool>
        var passwordValidation: Driver<Bool>
        var error: Signal<Error>
    }
    
    private var userSignUpUseCase: UserSignUpUseCaseProtocol
    
    private let minPasswordLength: Int = 5
    private let maxPasswordLength: Int = 15
    
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
        let passwordValidation = Driver.combineLatest(input.password, input.rePassword)
            .map { self.validatePassword($0, $1) }
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
                .asSignal(onErrorJustReturn: false)
            }
        
        return Output.init(
            signUp: signUp,
            passwordValidation: passwordValidation,
            error: errorTracker.asSignal()
        )
    }
    
    private func validatePassword(_ password: String, _ rePassword: String) -> Bool {
        guard
            password == rePassword,
            password.count >= minPasswordLength,
            password.count <= maxPasswordLength
        else { return false }
        return true
    }
}
