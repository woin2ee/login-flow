//
//  UserLoginUseCase.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/26.
//

import Foundation
import RxSwift
import SwiftyJSON

protocol UserLoginUseCaseProtocol {
    func execute(query: LoginQuery) -> Observable<Void>
}

final class UserLoginUseCase: UserLoginUseCaseProtocol {
    
    private var userRepository: UserRepositoryProtocol
    
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    func execute(query: LoginQuery) -> Observable<Void> {
        return userRepository.getToken(query: query)
            .do(onNext: { token in self.saveKeychain(token: token) })
            .map { _ in () }
    }
    
    private func saveKeychain(token: String) {
        let query: [CFString : Any] = [kSecClass : kSecClassGenericPassword,
                                 kSecAttrService : "Service name",
                                 kSecAttrAccount : "Account",
                                 kSecAttrGeneric : token]
        
        SecItemAdd(query as CFDictionary, nil)
    }
}
