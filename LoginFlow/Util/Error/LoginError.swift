//
//  LoginError.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/07/28.
//

import Foundation

struct LoginError: Error {
    static let defaultDescription = "아이디 혹은 비밀번호가 일치하지 않습니다."
    var description: String
}
