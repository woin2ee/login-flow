//
//  UserSignUpUseCase.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/08/02.
//

import RxSwift

protocol UserSignUpUseCaseProtocol {
    func execute(query: SignUpQuery) -> Observable<Bool>
}

final class UserSignUpUseCase: UserSignUpUseCaseProtocol {
    
    func execute(query: SignUpQuery) -> Observable<Bool> {
        return .of(false)
    }
}
