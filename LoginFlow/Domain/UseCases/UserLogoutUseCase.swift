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
    private var userDefaultRepository: UserDefaultsRepositoryProtocol
    
    init(
        keychainRepository: KeychainRepositoryProtocol,
        userDefaultRepository: UserDefaultsRepositoryProtocol
    ) {
        self.keychainRepository = keychainRepository
        self.userDefaultRepository = userDefaultRepository
    }
    
    func execute() -> Observable<Void> {
        guard let id = userDefaultRepository.getCurrentUserId() else {
            return .error(KeychainError.deleteFailure)
        }
        
        userDefaultRepository.removeCurrentUserId()
        
        if keychainRepository.delete(id: id) {
            return .of(())
        } else {
            return .error(KeychainError.deleteFailure)
        }
    }
}
