//
//  LoginViewModel.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/25.
//

import RxSwift
import RxCocoa
import SwiftyJSON

final class LoginViewModel: ViewModelType {
    
    struct Input {
        var loginRequest: Driver<Void>
        var signUpRequest: Driver<Void>
        var id: Driver<String>
        var password: Driver<String>
    }
    
    struct Output {
        var error: Driver<Error>
        var login: Driver<Void>
    }
    
    private var userLoginUseCase: UserLoginUseCase
    
    init(userLoginUseCase: UserLoginUseCase) {
        self.userLoginUseCase = userLoginUseCase
    }
    
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker.init()
        
        let idAndPassword = Driver.combineLatest(input.id, input.password)
        
        let login = input.loginRequest
            .withLatestFrom(idAndPassword)
            .flatMapFirst { id, password in
                return self.userLoginUseCase.execute(query: .init(id: id, password: password))
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        return Output.init(
            error: errorTracker.asDriver(),
            login: login
        )
    }
}
