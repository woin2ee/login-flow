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
    
    init(keychainRepository: KeychainRepositoryProtocol) {
        self.keychainRepository = keychainRepository
    }
    
    func execute() -> Observable<Void> {
        
        // FIXME: UserDefault 사용해서 ID 가져오기
        let id = "jaewon123"
        
        if keychainRepository.delete(id: id) {
            return .of(())
        } else {
            return .error(KeychainError.deleteFailure)
        }
    }
}
