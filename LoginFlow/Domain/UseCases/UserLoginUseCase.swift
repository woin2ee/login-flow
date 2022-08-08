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
    private var userDefaultsRepository: UserDefaultsRepositoryProtocol
    
    init(
        userRepository: UserRepositoryProtocol,
        keychainRepository: KeychainRepositoryProtocol,
        userDefaultsRepository: UserDefaultsRepositoryProtocol
    ) {
        self.userRepository = userRepository
        self.keychainRepository = keychainRepository
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func execute(query: LoginQuery) -> Observable<Void> {
        return userRepository.getToken(query: query)
            .do(onNext: {
                self.userDefaultsRepository.saveCurrentUserId(query.id)
                if self.keychainRepository.save(token: $0) == false {
                    throw KeychainError.saveFailure
                }
            })
            .map { _ in () }
    }
}
