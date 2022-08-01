//
//  TokenValidationUseCase.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/08/01.
//

import Foundation
import RxSwift

protocol TokenValidationUseCaseProtocol {
    func execute(id: String) -> Observable<Bool>
}

final class TokenValidationUseCase: TokenValidationUseCaseProtocol {
    
    private var keychainRepository: KeychainRepositoryProtocol
    private var userRepository: UserRepositoryProtocol
    
    init(
        keychainRepository: KeychainRepositoryProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.keychainRepository = keychainRepository
        self.userRepository = userRepository
    }
    
    func execute(id: String) -> Observable<Bool> {
        guard let token = keychainRepository.get(id: id) else { return .of(false) }
        return userRepository.checkToken(token: token)
    }
}
