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
    
    func getToken(query: LoginQuery) -> Observable<String> {
        let path: String = "/oauth/token"
        let query: String = "username=\(query.id)&password=\(query.password)"
        
        return networkService.request(path, query, .post)
            .map { json -> String in
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
                    return token
                case .badRequest:
                    guard let errorMessage = json["data"].string else {
                        throw JsonError.decodeFailure
                    }
                    throw SignUpError.init(description: errorMessage)
                }
            }
    }
}
