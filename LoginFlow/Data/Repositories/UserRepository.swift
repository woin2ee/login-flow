//
//  UserRepository.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/26.
//

import Foundation
import RxSwift
import SwiftyJSON

final class UserRepository: UserRepositoryProtocol {
    
    private var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getToken(query: LoginQuery) -> Observable<Token> {
        let path: String = "/oauth/token"
        let id = query.id
        let password = query.password
        let query: String = "username=\(id)&password=\(password)"
        
        return networkService.request(path, query, .post)
            .map { json -> Token in
                guard let code = json["code"].int else {
                    throw JsonError.decodeFailure
                }
                guard let httpStatusCode = HTTPStatusCode.init(rawValue: code) else {
                    throw NetworkError.undefinedStatusCode
                }
                
                switch httpStatusCode {
                case .ok:
                    guard let token = json["data"]["accessToken"].string else {
                        throw JsonError.decodeFailure
                    }
                    return .init(id: id, value: token)
                case .badRequest:
                    guard let errorMessage = json["data"].string else {
                        throw JsonError.decodeFailure
                    }
                    throw LoginError.init(description: errorMessage)
                }
            }
    }
    
    func checkToken(token: Token) -> Observable<Bool> {
        let path: String = "/api/member"
        
        return networkService.request(
            path,
            headers: (key: "X-AUTH-TOKEN", value: token.value),
            method: .get
        )
        .map {
            if $0["id"].string == token.id {
                return true
            } else {
                return false
            }
        }
    }
    
    func signUp(query: SignUpQuery) -> Observable<Void> {
        let path: String = "/api/member"
        let encoder = JSONEncoder.init()
        let httpBody = try? encoder.encode(query)
        
        return networkService.request(path, httpBody, .post)
            .map { if $0["state"].string != "CREATED" { throw SignUpError.anyError } }
    }
}
