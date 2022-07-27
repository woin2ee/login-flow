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
    
    private var networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getToken(query: LoginQuery) -> Observable<Token> {
        let path: String = "/oauth/token"
        let query: String = "username=\(query.id)&password=\(query.password)"
        return networkService.request(path, query)
    }
}
