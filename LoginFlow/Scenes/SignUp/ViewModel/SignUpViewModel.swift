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
        var signUpRequest: Signal<Void>
    }
    
    struct Output {
        var signUp: Signal<Bool>
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
            error: errorTracker.asSignal()
        )
    }
}
