//
//  UserRepositoryProtocol.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/26.
//

import Foundation

protocol UserRepositoryProtocol {
    func getToken(user: User) -> String
}
