//
//  UserLogoutUseCase.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/08/01.
//

import RxSwift

protocol UserLogoutUseCaseProtocol {
    func execute() -> Observable<Void>
}

final class UserLogoutUseCase: UserLogoutUseCaseProtocol {
    
    private var keychainRepository: KeychainRepositoryProtocol
    private var userDefaultsRepository: UserDefaultsRepositoryProtocol
    
    init(
        keychainRepository: KeychainRepositoryProtocol,
        userDefaultsRepository: UserDefaultsRepositoryProtocol
    ) {
        self.keychainRepository = keychainRepository
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func execute() -> Observable<Void> {
        guard let id = userDefaultsRepository.getCurrentUserId() else {
            return .error(KeychainError.deleteFailure)
        }
        
        userDefaultsRepository.removeCurrentUserId()
        
        if keychainRepository.delete(id: id) {
            return .of(())
        } else {
            return .error(KeychainError.deleteFailure)
        }
    }
}
