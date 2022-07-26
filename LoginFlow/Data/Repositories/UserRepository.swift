//
//  UserRepository.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/26.
//

import Foundation
import RxSwift

final class UserRepository: UserRepositoryProtocol {
    
    typealias Token = String
    
    func getToken(query: LoginQuery) -> Observable<Token> {
        return .of("Test Token")
    }
}
