//
//  UserRepositoryProtocol.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/26.
//

import Foundation

protocol UserRepositoryProtocol {
    associatedtype Token
    
    func getToken(user: User) -> Token
}
