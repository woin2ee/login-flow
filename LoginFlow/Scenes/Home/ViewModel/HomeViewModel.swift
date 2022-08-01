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
    }
    
    struct Output {
        var isloggedIn: Driver<Bool>
    }
    
    private var tokenValidationUseCase: TokenValidationUseCaseProtocol
    
    init(tokenValidationUseCase: TokenValidationUseCaseProtocol) {
        self.tokenValidationUseCase = tokenValidationUseCase
    }
    
    func transform(input: Input) -> Output {
        let isloggedIn = input.viewWillAppear
            .flatMapLatest {
                self.tokenValidationUseCase.execute(id: "jaewon123")
                    .asDriver(onErrorJustReturn: false)
            }
        
        return Output.init(
            isloggedIn: isloggedIn
        )
    }
}
