//
//  KeychainError.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/08/01.
//

import Foundation

enum KeychainError: Error {
    case saveFailure
    case updateFailure
    case getFailure
}
