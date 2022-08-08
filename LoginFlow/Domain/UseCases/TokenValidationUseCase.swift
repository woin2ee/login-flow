//
//  TokenValidationUseCase.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/08/01.
//

import Foundation
import RxSwift

protocol TokenValidationUseCaseProtocol {
    func execute() -> Observable<Bool>
}

final class TokenValidationUseCase: TokenValidationUseCaseProtocol {
    
    private var keychainRepository: KeychainRepositoryProtocol
    private var userRepository: UserRepositoryProtocol
    private var userDefaultsRepository: UserDefaultsRepositoryProtocol
    
    init(
        keychainRepository: KeychainRepositoryProtocol,
        userRepository: UserRepositoryProtocol,
        userDefaultsRepository: UserDefaultsRepositoryProtocol
    ) {
        self.keychainRepository = keychainRepository
        self.userRepository = userRepository
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func execute() -> Observable<Bool> {
        guard
            let id = userDefaultsRepository.getCurrentUserId(),
            let token = keychainRepository.get(id: id)
        else { return .of(false) }
        
        return userRepository.checkToken(token: token)
    }
}
