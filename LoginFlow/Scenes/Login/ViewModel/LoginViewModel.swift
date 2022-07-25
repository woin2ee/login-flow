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
        var login: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let idAndPassword = Driver.combineLatest(input.id, input.password)
        
        let login = input.loginRequest
            .withLatestFrom(idAndPassword)
            .map { _, _ in }
        
        return Output.init(login: login)
    }
}
