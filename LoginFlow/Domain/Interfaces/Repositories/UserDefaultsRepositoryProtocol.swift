//
//  UserDefaultsRepositoryProtocol.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/08/01.
//

import Foundation

protocol UserDefaultsRepositoryProtocol {
    func saveCurrentUserId(_ id: String)
    func getCurrentUserId() -> String?
    func removeCurrentUserId()
}
