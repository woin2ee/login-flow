//
//  UserDefaultsRepository.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/08/01.
//

import Foundation

private enum UserDefaultsKey: String {
    case id = "id"
}

final class UserDefaultsRepository: UserDefaultsRepositoryProtocol {
    
    private var storage = UserDefaults.standard
    
    func saveCurrentUserId(_ id: String) {
        storage.setValue(id, forKey: UserDefaultsKey.id.rawValue)
    }
    
    func getCurrentUserId() -> String? {
        return storage.value(forKey: UserDefaultsKey.id.rawValue) as? String
    }
    
    func removeCurrentUserId() {
        storage.removeObject(forKey: UserDefaultsKey.id.rawValue)
    }
}
