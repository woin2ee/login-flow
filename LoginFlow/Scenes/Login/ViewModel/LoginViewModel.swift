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
    
    // Input stream 이 Output stream 으로 연결 될 수 있도록 구성(변환이라고 표현함)
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker.init()
        
        let idAndPassword = Driver.combineLatest(input.id, input.password)
        
        let login = input.loginRequest
            .withLatestFrom(idAndPassword)
            .flatMapFirst { id, password in
                return self.userLoginUseCase.execute(query: .init(id: id, password: password))
                    .trackError(errorTracker) // error 발생 시 errorTracker 에게 event 위임
                    .asDriverOnErrorJustComplete()
            }
        
        return Output.init(
            error: errorTracker.asDriver(),
            login: login
        )
    }
}
