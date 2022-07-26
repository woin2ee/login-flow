//
//  LoginViewModel.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/25.
//

import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    
    struct Input {
        var loginRequest: Driver<Void>
        var signUpRequest: Driver<Void>
        var id: Driver<String>
        var password: Driver<String>
    }
    
    struct Output {
        var login: Observable<String>
    }
    
    private var userLoginUseCase: UserLoginUseCase
    
    init(userLoginUseCase: UserLoginUseCase) {
        self.userLoginUseCase = userLoginUseCase
    }
    
    func transform(input: Input) -> Output {
        let idAndPassword = Driver.combineLatest(input.id, input.password)
        
        let login = input.loginRequest
            .withLatestFrom(idAndPassword)
            .asObservable()
            .flatMapFirst { id, password in
                return self.userLoginUseCase.execute(query: .init(id: id, password: password))
            }
        
        return Output.init(login: login)
    }
}
