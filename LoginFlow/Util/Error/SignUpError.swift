//
//  SignUpError.swift
//  LoginFlow
//
//  Created by Jaewon on 2022/08/02.
//

import Foundation

enum SignUpError: String, Error {
    case anyError = "해당 아이디를 사용중인 회원이 이미 존재합니다."
}
