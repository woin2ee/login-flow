//
//  KeychainRepository.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/31.
//

import Foundation

final class KeychainRepository: KeychainRepositoryProtocol {
    private let serviceName = "LoginFlow"
    
    func save(token: Token) -> Bool {
        let query: [CFString : Any] = [kSecClass : kSecClassGenericPassword,
                                 kSecAttrService : serviceName,
                                 kSecAttrAccount : token.id,
                                 kSecAttrGeneric : token.value]
        
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    func update(token: Token) -> Bool {
        return false
    }
    
    func get(id: String) -> Token? {
        let query: [CFString : Any] = [kSecClass : kSecClassGenericPassword,
                                 kSecAttrService : serviceName,
                                 kSecAttrAccount : id,
                                  kSecMatchLimit : kSecMatchLimitOne,
                            kSecReturnAttributes : true,
                                  kSecReturnData : true]
        
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return nil }
        
        guard let existingItem = item as? [CFString : Any],
              let tokenValue = existingItem[kSecAttrGeneric] as? String
        else { return nil }
        
        return .init(id: id, value: tokenValue)
    }
    
    func delete(id: String) -> Bool {
        let query: [CFString : Any] = [kSecClass : kSecClassGenericPassword,
                                 kSecAttrService : serviceName,
                                 kSecAttrAccount : id]
        
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
