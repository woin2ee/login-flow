//
//  UserRepositoryProtocol.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/26.
//

import RxSwift

protocol UserRepositoryProtocol {
    func getToken(query: LoginQuery) -> Observable<Token>
    func checkToken(token: Token) -> Observable<Bool>
}
