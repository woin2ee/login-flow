//
//  NetworkService.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/26.
//

import Foundation
import RxSwift

protocol NetworkServiceProtocol {
    associatedtype Token
    
    func request(_ path: String, _ query: String) -> Observable<Token>
}

final class NetworkService: NetworkServiceProtocol {
    
    typealias Token = String
    
    private let endPoint: String = "localhost:8080"
    
    func request(_ path: String, _ query: String) -> Observable<Token> {
        let absolutePath = "\(endPoint)/\(path)?\(query)"
        
        return .of("Test Token")
    }
}
