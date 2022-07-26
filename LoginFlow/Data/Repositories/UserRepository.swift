//
//  UserRepository.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/26.
//

import Foundation
import RxSwift

enum RequestError: Error {
    case someError
}

final class UserRepository: UserRepositoryProtocol {
    
    typealias Token = String
    
    private var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getToken(query: LoginQuery) -> Observable<Token> {
        guard
            let url = URL.init(string: "localhost:8080/oauth/token?username=jaewon123&password=jaewon123")
        else { return .error(RequestError.someError) }
        let urlRequest = URLRequest.init(url: url)
        networkService.request(urlRequest)
        return .of("Test Token")
    }
}
