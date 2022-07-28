//
//  UserRepositoryProtocol.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/26.
//

import Foundation
import RxSwift
import SwiftyJSON

protocol UserRepositoryProtocol {
    func getToken(query: LoginQuery) -> Observable<String>
}
