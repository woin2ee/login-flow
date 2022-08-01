//
//  UserLoginUseCase.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/26.
//

import Foundation
import RxSwift

protocol UserLoginUseCaseProtocol {
    func execute(query: LoginQuery) -> Observable<Void>
}

final class UserLoginUseCase: UserLoginUseCaseProtocol {
    
    private var userRepository: UserRepositoryProtocol
    private var keychainRepository: KeychainRepositoryProtocol
    
    init(
        userRepository: UserRepositoryProtocol,
        keychainRepository: KeychainRepositoryProtocol
    ) {
        self.userRepository = userRepository
        self.keychainRepository = keychainRepository
    }
    
    func execute(query: LoginQuery) -> Observable<Void> {
        return userRepository.getToken(query: query)
            .do(onNext: {
                if self.keychainRepository.save(token: $0) == false {
                    throw KeychainError.saveFailure
                }
            })
            .map { _ in () }
    }
}
