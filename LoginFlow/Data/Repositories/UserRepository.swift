//
//  UserRepository.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/26.
//

import Foundation

final class UserRepository: UserRepositoryProtocol {
    
    typealias Token = String
    
    func getToken(user: User) -> Token {
        return Token.init()
    }
}
