//
//  KeychainRepositoryProtocol.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/31.
//

import Foundation

protocol KeychainRepositoryProtocol {
    func save(token: Token) -> Bool
    func update(token: Token) -> Bool
    func get(id: String) -> Token?
    func delete(id: String) -> Bool
}
