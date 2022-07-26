//
//  UserRepositoryProtocol.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/26.
//

import Foundation
import RxSwift

protocol UserRepositoryProtocol {
    associatedtype Token
    
    func getToken(query: LoginQuery) -> Observable<Token>
}
