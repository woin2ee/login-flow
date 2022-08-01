//
//  HomeViewModel.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/26.
//

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    
    struct Input {
        var viewWillAppear: Signal<Void>
        var logoutRequest: Signal<Void>
    }
    
    struct Output {
        var isloggedIn: Driver<Bool>
        var logout: Driver<Void>
    }
    
    private var tokenValidationUseCase: TokenValidationUseCaseProtocol
    private var userLogoutUseCase: UserLogoutUseCaseProtocol
    
    init(
        tokenValidationUseCase: TokenValidationUseCaseProtocol,
        userLogoutUseCase: UserLogoutUseCaseProtocol
    ) {
        self.tokenValidationUseCase = tokenValidationUseCase
        self.userLogoutUseCase = userLogoutUseCase
    }
    
    func transform(input: Input) -> Output {
        let isloggedIn = input.viewWillAppear
            .flatMapLatest {
                self.tokenValidationUseCase.execute(id: "jaewon123")
                    .asDriver(onErrorJustReturn: false)
            }
        
        let logout = input.logoutRequest
            .flatMapFirst {
                    return self.userLogoutUseCase.execute()
                        .asDriver(onErrorDriveWith: .empty())
            }
        
        return Output.init(
            isloggedIn: isloggedIn,
            logout: logout
        )
    }
}
