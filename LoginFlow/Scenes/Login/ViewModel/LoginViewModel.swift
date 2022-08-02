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
        var loginRequest: Signal<Void>
        var id: Driver<String>
        var password: Driver<String>
    }
    
    struct Output {
        var error: Signal<Error>
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
                self.userLoginUseCase.execute(query: .init(id: id, password: password))
                    .trackError(errorTracker) // error 발생 시 errorTracker 에게 event 공유
                    .asDriver(onErrorDriveWith: .empty()) // 결국엔 error 를 무시한다는 의미
            }
        
        return Output.init(
            error: errorTracker.asSignal(),
            login: login
        )
    }
}
