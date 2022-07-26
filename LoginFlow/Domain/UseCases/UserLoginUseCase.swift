//
//  UserLoginUseCase.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/26.
//

import Foundation

protocol UserLoginUseCaseProtocol {
    associatedtype Token
    
    func execute(user: User) -> Token
}

final class UserLoginUseCase: UserLoginUseCaseProtocol {
    
    typealias Token = String
    
    private var userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(user: User) -> Token {
        return userRepository.getToken(user: user)
    }
}
