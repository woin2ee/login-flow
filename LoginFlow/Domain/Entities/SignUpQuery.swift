//
//  SignUpQuery.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/08/02.
//

import Foundation

struct SignUpQuery: Encodable {
    let id: String
    let password: String
    let memberInfo: MemberInfo
}

struct MemberInfo: Encodable {
    let email: String
    let passport: String
}
