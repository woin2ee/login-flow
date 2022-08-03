//
//  UserSignUpUseCase.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/08/02.
//

import RxSwift

protocol UserSignUpUseCaseProtocol {
    func execute(query: SignUpQuery) -> Observable<Void>
}

final class UserSignUpUseCase: UserSignUpUseCaseProtocol {
    
    private var userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func execute(query: SignUpQuery) -> Observable<Void> {
        return userRepository.signUp(query: query)
    }
}
